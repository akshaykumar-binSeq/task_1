import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:task_1/model/item_model.dart';

class API {
  var headers = {
    'accept': 'application/json',
  };

  Future<List<Items>?> fetchItems(DateTime dateTime) async {
    return await http
        .get(getUri(dateTime: dateTime.subtract(const Duration(days: 1))))
        .then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
        final itemResponse = ItemResponse.fromJson(jsonDecode(value.body));

        return itemResponse.items;
      } else {
        return null;
      }
    }).onError((error, stackTrace) {
      log(error.toString());
      return null;
    });
  }

  Uri getUri({required DateTime dateTime}) {
    var params = {
      'q': 'created:>${dateTime.toIso8601String().split('T').first}',
      'sort': 'stars',
      'order': 'desc',
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    return Uri.parse('https://api.github.com/search/repositories?$query');
  }
}
