import 'package:flutter/material.dart';

enum DeliveryOptions { pickup, delivery }

enum PaymentOptions { tunai, creaditCard, eWallet }

class OptionProvider extends ChangeNotifier{
  DeliveryOptions selectedDelOptions = DeliveryOptions.delivery;
  PaymentOptions selectedPayOptions = PaymentOptions.eWallet;

  DeliveryOptions get selectDelivery => selectedDelOptions;
  PaymentOptions get selectPayment => selectedPayOptions;

  void setDeliveryOptions(DeliveryOptions option){
    selectedDelOptions = option;
    notifyListeners();
  }

  void setPaymentOptions(PaymentOptions option){
    selectedPayOptions = option;
    notifyListeners();
  }
}