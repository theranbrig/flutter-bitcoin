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
  CoinData coinData = CoinData();
  String selectedCurrency = 'USD';
  List coinInformation;

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
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: currencyListItems,
    );
  }

  List<Widget> getCryptoList(List coinData) {
    List<Widget> cryptoItems = [];
    for (var coin in coinData) {
      double coinPrice = coin['price'];
      var item = CryptoCard(
          cryptoCurrency: coin['crypto'],
          selectedCurrency: selectedCurrency,
          rate: coinPrice.toStringAsFixed(0));
      cryptoItems.add(item);
    }
    return cryptoItems;
  }

  getData() async {
    coinInformation = await coinData.getAllCoinData(selectedCurrency);
    setState(() {
      getCryptoList(coinInformation);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getData();
    });
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
          Column(
            children:
                coinInformation != null ? getCryptoList(coinInformation) : [],
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

class CryptoCard extends StatelessWidget {
  const CryptoCard(
      {@required this.cryptoCurrency,
      @required this.selectedCurrency,
      @required this.rate});

  final String cryptoCurrency;
  final String selectedCurrency;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            '1 $cryptoCurrency = $rate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
