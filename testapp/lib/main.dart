import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Exchange Rate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExchangeRatePage(),
    );
  }
}

class ExchangeRatePage extends StatefulWidget {
  const ExchangeRatePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExchangeRatePageState createState() => _ExchangeRatePageState();
}

class _ExchangeRatePageState extends State<ExchangeRatePage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController baseCurrencyController = TextEditingController();
  final TextEditingController targetCurrencyController =
      TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String result = '';

  Future<Map<String, dynamic>> fetchExchangeRates(
      String date, String baseCurrency) async {
    final response = await http
        .get(Uri.parse('https://api.exchangerate.host/2020-04-05?base=USD'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Exhange rates failed to load");
    }
  }

  void calculateRates() {
    // Getting user inputs
    String date = dateController.text;
    String baseCurrency = baseCurrencyController.text;
    String targetCurrency = targetCurrencyController.text;
    double amount = double.parse(amountController.text);

    //taking exchange rates
    fetchExchangeRates(date, baseCurrency).then((data) {
      double rate = data['rates'][targetCurrency];
      double convertedAmount = amount * rate;
      setState(() {
        result = '$amount $baseCurrency = $convertedAmount $targetCurrency';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Exchange Rate'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Select Date'),
            ),
            TextField(
              controller: targetCurrencyController,
              decoration: InputDecoration(labelText: 'Target Currency'),
            ),
            TextField(
              controller: baseCurrencyController,
              decoration: InputDecoration(labelText: "Base Currency"),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            ElevatedButton(
              onPressed: calculateRates,
              child: Text('Calculate'),
            ),
            Text(result),
          ],
        ),
      ),
    );
  }
}
