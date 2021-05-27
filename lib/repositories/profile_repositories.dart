import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:active_ecommerce_flutter/data_model/profile_counters_response.dart';

import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class ProfileRepository {
  Future<ProfileCountersResponse> getProfileCountersResponse() async {
    final response = await http.get(
      Uri.parse("${AppConfig.BASE_URL}/profile/counters/${user_id.value}"),
      headers: {"Authorization": "Bearer ${access_token.value}"},
    );
    return profileCountersResponseFromJson(response.body);
  }
}
