import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyamgo/Services/firestore.dart';
import 'package:nyamgo/component/my_card.dart';
import 'package:nyamgo/provider/cart_provider.dart';
import 'package:nyamgo/provider/option_provider.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

// enum DeliveryOptions { pickup, delivery }

// enum PaymentOptions { tunai, creaditCard, eWallet }

class _PaymentPageState extends State<PaymentPage> {
  double? deviceHeight, deviceWidth;
  // DeliveryOptions selectedOptions = DeliveryOptions.delivery;
  // PaymentOptions selectedPayment = PaymentOptions.eWallet;
  bool isEditing = false;
  String address = 'Jl. Mawar No. 123, Jakarta';
  final TextEditingController addressController = TextEditingController();

  Firestore firestore = Firestore();
  String getPaymentLabel(PaymentOptions? option) {
    switch (option) {
      case PaymentOptions.tunai:
        return 'Tunai';
      case PaymentOptions.creaditCard:
        return 'Credit Card';
      case PaymentOptions.eWallet:
        return 'E-wallet';
      default:
        return 'Pilih Metode';
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    final cartProvider = Provider.of<CartProvider>(context);
    final total = cartProvider.total;
    final dataItem = cartProvider.item;
    final optionProvider = Provider.of<OptionProvider>(context);
    final selectedOptions = optionProvider.selectDelivery;
    final paymentMethodOpt = optionProvider.selectPayment.name;
    final deliveryMethodOpt = optionProvider.selectDelivery.name;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    cartPayment(),
                    deliveryMethod(context),
                    selectedOptions == DeliveryOptions.delivery
                        ? addressUser()
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            buttonPayment(
              itemCart: dataItem,
              total: total,
              paymentMethod: paymentMethodOpt,
              deliveryMethod: deliveryMethodOpt,
            ),
          ],
        ),
      ),
    );
  }

  Widget cartPayment() {
    String userId = firestore.auth.currentUser!.uid;
    final provider = Provider.of<OptionProvider>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.getCart(userId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final List data = snapshot.data!.docs.map((e) => e.data()).toList();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<CartProvider>(context, listen: false).setItems(data);
          });

          final total = Provider.of<CartProvider>(context).total;
          // Provider.of<CartProvider>(context, listen: false).setItems(data);
          // final total = Provider.of<CartProvider>(context).total;
          // double total = 0;
          // for (var e in data) {
          //   double price = double.parse(e['price'].toString());
          //   int quantity = e['quantity'] ?? 1;
          //   total += price * quantity;
          // }
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = data[index];

                  return MyCard(
                    child: ListTile(
                      leading: item['image'] != null
                          ? Image.network(
                              item['image'],
                              width: 100,
                              height: 100,
                            )
                          : const Icon(Icons.image_not_supported),
                      title: Text(item['name']),
                      subtitle: Text(item['category']),
                      trailing: Text('\$${item['price']}'),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(getPaymentLabel(provider.selectPayment)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25)),
                                  ),
                                  builder: (
                                    BuildContext context,
                                  ) {
                                    return StatefulBuilder(
                                      builder: (context,
                                          StateSetter setStateBottomSheet) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                            left: 20,
                                            right: 20,
                                            top: 20,
                                          ),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxHeight: deviceHeight! * 0.6),
                                            child: paymentOptions(
                                                setStateBottomSheet,
                                                provider.selectPayment,
                                                (value) {
                                              // setState(() {
                                              //   provider.selectedPayOptions =
                                              //       value;
                                              // });

                                              provider.setPaymentOptions(value);
                                            }, context),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.more_horiz)),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text("\$${total.toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 18)),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        } else {
          return const Center(
            child: Text('No Data'),
          );
        }
      },
    );
  }

  Widget deliveryMethod(BuildContext context) {
    final provider = Provider.of<OptionProvider>(context);
    final selectedDelivery = provider.selectDelivery;
    return Container(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Options',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                  )
                ]),
            child: Column(
              children: [
                RadioListTile<DeliveryOptions>(
                    title: const Text('Delivery'),
                    value: DeliveryOptions.delivery,
                    groupValue: selectedDelivery,
                    activeColor: const Color(0xffFA4A0C),
                    onChanged: (value) => provider.setDeliveryOptions(value!)),
                RadioListTile<DeliveryOptions>(
                    title: const Text('Pick Up'),
                    value: DeliveryOptions.pickup,
                    groupValue: selectedDelivery,
                    activeColor: const Color(0xffFA4A0C),
                    onChanged: (value) => provider.setDeliveryOptions(value!)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buttonPayment({
    required List itemCart,
    required double total,
    required String paymentMethod,
    required String deliveryMethod,
  }) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(350, 60),
            backgroundColor: const Color(0xffFA4A0C),
          ),
          onPressed: () async {
            if (itemCart.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Keranjang kosong.')),
              );
              return;
            }
            String userId = firestore.auth.currentUser!.uid;
            String addressUser = addressController.text.trim();
            await firestore.addOrder(
              userId: userId,
              itemCart: itemCart,
              total: total,
              paymentMethod: paymentMethod,
              deliveryMethod: deliveryMethod,
              address: addressUser.isEmpty ? address : addressUser,
            );
            Provider.of<CartProvider>(context, listen:false).clearCart();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order Telah dibuat')));
            Navigator.pushReplacementNamed(context, 'orderStatus');
          },
          child: const Text(
            'Complete Payment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget paymentOptions(
      StateSetter setStateBottomSheet,
      PaymentOptions selected,
      ValueChanged<PaymentOptions> onSelect,
      BuildContext context) {
    final provider = Provider.of<OptionProvider>(context);
    final selectedPayment = provider.selectPayment;
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Metode Pembayaran',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xffFA4A0C),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: RadioListTile<PaymentOptions>(
              title: const Row(
                children: [
                  Icon(Icons.money_off_outlined, color: Color(0xffFA4A0C)),
                  SizedBox(width: 10),
                  Text('Tunai'),
                ],
              ),
              activeColor: const Color(0xffFA4A0C),
              value: PaymentOptions.tunai,
              groupValue: selectedPayment,
              onChanged: (value) => provider.setPaymentOptions(value!),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: RadioListTile<PaymentOptions>(
              title: const Row(
                children: [
                  Icon(Icons.credit_card, color: Color(0xffFA4A0C)),
                  SizedBox(width: 10),
                  Text('Credit Card'),
                ],
              ),
              activeColor: const Color(0xffFA4A0C),
              value: PaymentOptions.creaditCard,
              groupValue: selectedPayment,
              onChanged: (value) => provider.setPaymentOptions(value!),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: RadioListTile<PaymentOptions>(
              title: const Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Color(0xffFA4A0C)),
                  SizedBox(width: 10),
                  Text('E-wallet'),
                ],
              ),
              activeColor: const Color(0xffFA4A0C),
              value: PaymentOptions.eWallet,
              groupValue: selectedPayment,
              onChanged: (value) => provider.setPaymentOptions(value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget addressUser() {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Address Detail',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                )
              ],
            ),
            child: isEditing
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: addressController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your address',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                addressController.text = address;
                                isEditing = false;
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                address = addressController.text.trim();
                                isEditing = false;
                              });
                              String userId = firestore.auth.currentUser!.uid;

                              await firestore.db
                                  .collection('users')
                                  .doc(userId)
                                  .set({
                                'address': address,
                              }, SetOptions(merge: true));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffFA4A0C),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(address),
                      )),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        child: const Text(
                          'Change',
                          style: TextStyle(
                            color: Color(0xffFA4A0C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
