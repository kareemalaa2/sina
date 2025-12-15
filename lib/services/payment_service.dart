

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mycar/models/response_model.dart';
import 'package:uuid/uuid.dart';

class PaymentService {
  

static Dio dio = Dio(
  BaseOptions(
baseUrl: "https://api.moyasar.com/v1",
  ),
);

  static Future<ResponseModel> generatePaymentLink({
    required String userId,
    required String countryId,
    required String currency,
    required String moyasarPK,
    required String cardHolderName,
    required String cardNumber,
    required String cvvCode,
    required String expiryDate,
    required double amount,
  }) async {
    try {
      final res = await dio.post(
        "/payments",
        data: {
          "given_id": const Uuid().v4(),
          "amount": int.parse((amount).toStringAsFixed(2).replaceAll(".", "")),
          "currency": currency,
          "description": "Payment for order #",
          "callback_url": "https://sinaeiati.com",
          "metadata": {
            "userId": userId,
            "countryId": countryId,
          },
          "source": {
            "type": "creditcard",
            "name": cardHolderName,
            "number": cardNumber.replaceAll(" ", ""),
            "cvc": cvvCode,
            "month": expiryDate.split("/")[0],
            "year": expiryDate.split("/")[1],  
            "statement_descriptor": "Snaeiati",  
            "3ds": true,
            "manual": false,
            "save_card": false
          }
        },
        options: Options(
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Basic ${base64Encode(utf8.encode(moyasarPK))}',
          },
        ),
      );
      return ResponseModel(
        data: res.data['source']['transaction_url'],
        success: true,
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return ResponseModel(
            success: false,
            message: "check_network",
            data: null,
          );
        } else {
          return ResponseModel(
            success: false,
            message: "check_network",
            data: null,
          );
        }
      } else {
        return ResponseModel(
          success: false,
          message: "check_network",
          data: null,
        );
      }
    }
  }
}