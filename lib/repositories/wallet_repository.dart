import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/wallet_balance_response.dart';
import 'package:active_ecommerce_flutter/data_model/wallet_recharge_response.dart';
import 'package:flutter/foundation.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class WalletRepository {
  Future<WalletBalanceResponse> getBalance() async {
    final response = await http.get(
      Uri.parse("${AppConfig.BASE_URL}/wallet/balance/${user_id.$}"),
      headers: {"Authorization": "Bearer ${access_token.$}"},
    );
    //print(response.body.toString());
    return walletBalanceResponseFromJson(response.body);
  }

  Future<WalletRechargeResponse> getRechargeList({int page = 1}) async {
    final response = await http.get(
      Uri.parse(
          "${AppConfig.BASE_URL}/wallet/history/${user_id.$}?page=${page}"),
      headers: {"Authorization": "Bearer ${access_token.$}"},
    );
    return walletRechargeResponseFromJson(response.body);
  }
}
