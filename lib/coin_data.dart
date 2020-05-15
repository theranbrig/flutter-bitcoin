import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getCoinData(String selectedCurrency, String cryptoCoin) async {

    String url =
        'https://rest.coinapi.io/v1/exchangerate/$cryptoCoin/$selectedCurrency';
    var response = await http.get(url, headers: {"X-CoinAPI-Key": apiKey});
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = jsonDecode(data);
      var price = decodedData['rate'];
      return price;
    } else {
      print(response.statusCode);
    }
  }

  Future getAllCoinData(String selectedCurrency) async {
    List cryptoCoinValues = [];
    for (var crypto in cryptoList) {
      var price = await getCoinData(selectedCurrency, crypto);
      var item = {
        "price": price,
        "selectedCurrency": selectedCurrency,
        "crypto": crypto
      };
      cryptoCoinValues.add(item);
    }
    return cryptoCoinValues;
  }
}
