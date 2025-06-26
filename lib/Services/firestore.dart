import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nyamgo/models/items.dart';
import 'package:path/path.dart' as p;

class Firestore {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  Map? currentUser;
  StreamSubscription? itemSubs;

  Future<Map?> getUserData({required String uid}) async {
    try {
      DocumentSnapshot doc = await db.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return doc.data() as Map<String, dynamic>;
      } else {
        print("Dokumen dengan UID $uid tidak ditemukan atau kosong");
        return {};
      }
    } catch (e) {
      print("Error saat mengambil data user: $e");
      return {};
    }
  }

  Future<bool> loginUser({String? email, String? password}) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      if (user.user != null) {
        currentUser = await getUserData(uid: user.user!.uid);
        await db
            .collection('users')
            .doc(user.user!.uid)
            .update({'last_login': FieldValue.serverTimestamp()});
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<bool> registerUser(
      {String? name,
      String? email,
      String? password,
      String? phoneNumber,
      File? profilePicture,
      Timestamp? lastLogin}) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      String userId = user.user!.uid;
      String profilePicUrl;

      if (profilePicture != null) {
        String fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
            p.extension(profilePicture.path);
        Reference ref = storage.ref('images/profile_picture/$userId/$fileName');
        UploadTask task = ref.putFile(profilePicture);
        TaskSnapshot snapshot = await task;
        profilePicUrl = await snapshot.ref.getDownloadURL();
      } else {
        profilePicUrl =
            "https://firebasestorage.googleapis.com/v0/b/nyamgo-5d83c.firebasestorage.app/o/images%2Fdefault_user.png?alt=media&token=70b68c0a-6c09-41f5-8881-f12897989abb";
      }

      await db.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'profile_picture': profilePicUrl,
        'role': 'user',
        'last_login': lastLogin,
      });
      return true;
    } catch (e) {
      print("Error during registration: $e");
      return false;
    }
  }

  Stream<DocumentSnapshot> getCurrentUser() {
    var ref = db.collection('users').doc(auth.currentUser!.uid);
    return ref.snapshots().map((snapshot) {
      return snapshot;
    });
  }

  Future<void> addItems(Items item) async {
    try {
      String? imageItem;
      if (item.imagePath != null) {
        String imageFile = Timestamp.now().millisecondsSinceEpoch.toString() +
            p.extension(item.imagePath!.path);
        Reference ref =
            storage.ref('images/imageItem/${item.category}/$imageFile');
        UploadTask task = ref.putFile(item.imagePath!);
        TaskSnapshot snapshot = await task;
        imageItem = await snapshot.ref.getDownloadURL();
      }

      DocumentReference docRef = db.collection('items').doc();
      String newId = docRef.id;

      await db.collection('items').add({
        'id': newId,
        'name': item.name,
        'image': imageItem ?? item.imageUrl,
        'price': item.price,
        'category': item.category,
      });
      print('Berhasil memasukan data');
    } catch (e) {
      print('gagal memasukan data, $e');
    }
  }

  Stream<QuerySnapshot> getItem() {
    return db.collection('items').snapshots();
  }

  Future<void> addToCart(Items item, String userId) async {
    try {
      userId = auth.currentUser!.uid;
      await db
          .collection('cart')
          .doc(userId)
          .collection('items')
          .doc(item.id)
          .set({
        'id': item.id,
        'name': item.name,
        'image': item.imagePath ?? item.imageUrl,
        'price': item.price,
        'category': item.category,
        'quantity': 1,
      });
      print('Item berhasil ditambahkan ke keranjang');
    } catch (e) {
      print('Item gagal ditambahkan ke keranjang $e');
    }
  }

  Stream<QuerySnapshot> getCart(String userId) {
    userId = auth.currentUser!.uid;
    return db.collection('cart').doc(userId).collection('items').snapshots();
  }

  Future<void> updateQuantityCart(
      String userId, String itemId, int newQuantity) async {
    try {
      userId = auth.currentUser!.uid;

      if (newQuantity <= 0) {
        return await db
            .collection('cart')
            .doc(userId)
            .collection('items')
            .doc(itemId)
            .delete();
      }
      return await db
          .collection('cart')
          .doc(userId)
          .collection('items')
          .doc(itemId)
          .update({'quantity': newQuantity});
    } catch (e) {
      print('Gagal untuk Update quantity $e');
    }
  }

  Future<void> deleteCart(String userId, String itemId) async {
    return await db
        .collection('cart')
        .doc(userId)
        .collection('items')
        .doc(itemId)
        .delete();
  }

  Future<void> addOrder({required String userId, required List itemCart,required double total,
      required String paymentMethod,required String deliveryMethod,required String? address}) async {
    try {
      DocumentReference docRef = db.collection('order').doc();
      String newId = docRef.id;
      await docRef.set({
        'orderId': newId,
        'userId': userId,
        'items': itemCart,
        'total': total,
        'paymentMethod': paymentMethod,
        'deliveryMethod': deliveryMethod,
        'address': address ?? '',
        'createdAt': Timestamp.now(),
        'status': 'Di Proses',
      });

      final cartSnapshot = await db.collection('cart').doc(userId).collection('items').get();
      for(DocumentSnapshot doc in cartSnapshot.docs){
        await doc.reference.delete();
      }

      print('Order berhasil dibuat');
    } catch (e) {
      print('Order gagal dibuat $e');
    }
  }

  Stream<QuerySnapshot> getOrderDetailInProcess(String orderId){
    return db.collection('order').where('orderId', isEqualTo: orderId).snapshots();
  }

  Stream<QuerySnapshot> getOrderHistory(){
    return db.collection('order').where('status', isEqualTo: 'Pesanan Selesai').snapshots();
  }
  
}
