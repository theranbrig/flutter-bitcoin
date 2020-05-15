import 'dart:convert';

import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String displayRate;

  DropdownButton<String> getAndroidDropdown() {
    List<DropdownMenuItem<String>> currencyListItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      currencyListItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencyListItems,
      onChanged: (value) {
        selectedCurrency = value;
      },
    );
  }

  CupertinoPicker getIosPicker() {
    List<Text> currencyListItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      currencyListItems.add(newItem);
    }
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        print(currenciesList[selectedIndex]);
        selectedCurrency = currenciesList[selectedIndex];
        getData();
      },
      children: currencyListItems,
    );
  }

  Card createCard(rate, currency, coin) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $coin = ${rate ?? 'Loading...'} $currency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void getData() async {

    String url =
        'https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurrency';
    var response = await http.get(url, headers: {"X-CoinAPI-Key": apiKey});
    var data = response.body;
    print(data);
    var decodedData = jsonDecode(data);
    setState(() {
      double coinConversionRate = decodedData['rate'];
      displayRate = coinConversionRate.toStringAsFixed(2);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ${displayRate ?? 'Loading...'} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? getIosPicker() : getAndroidDropdown()),
        ],
      ),
    );
  }
}
