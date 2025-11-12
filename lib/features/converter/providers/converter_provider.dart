import 'package:currensee_pkr/data/services/api_service.dart';
import 'package:currensee_pkr/data/services/firestore_service.dart';
import 'package:flutter/material.dart';

class ConverterProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FirestoreService _firestoreService = FirestoreService();

  String _baseCurrency = 'USD';
  String _targetCurrency = 'EUR';
  double _amount = 1.0;
  double _result = 0.0;
  double _rate = 0.0;
  bool _isLoading = false;

  String get baseCurrency => _baseCurrency;
  String get targetCurrency => _targetCurrency;
  double get amount => _amount;
  double get result => _result;
  double get rate => _rate;
  bool get isLoading => _isLoading;

  ConverterProvider() {
    _firestoreService.getUserPreferences().listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        final defaultCurrency = data['defaultBaseCurrency'] as String?;
        if (defaultCurrency != null && defaultCurrency != _baseCurrency) {
          _baseCurrency = defaultCurrency;
          getConversionRate(); // No notifyListeners() needed, getConversionRate() will do it
        }
      }
    });
    getConversionRate();
  }

  void setBaseCurrency(String currency) {
    _baseCurrency = currency;
    getConversionRate();
  }

  void setTargetCurrency(String currency) {
    _targetCurrency = currency;
    getConversionRate();
  }

  void setAmount(String amountStr) {
    try {
      _amount = double.parse(amountStr);
    } catch (e) {
      _amount = 0.0;
    }
    _calculateResult();
    notifyListeners();
  }

  void swapCurrencies() {
    final temp = _baseCurrency;
    _baseCurrency = _targetCurrency;
    _targetCurrency = temp;
    getConversionRate();
  }

  Future<void> getConversionRate() async {
    _isLoading = true;
    notifyListeners();
    try {
      final rates = await _apiService.getExchangeRates(_baseCurrency);
      if (rates.containsKey(_targetCurrency)) {
        _rate = rates[_targetCurrency];
      } else {
        _rate = 0.0; // Target currency not found in rates
      }
      _calculateResult();
    } catch (e) {
      print(e);
      _rate = 0.0;
      _result = 0.0;
    }
    _isLoading = false;
    notifyListeners();
  }

  void _calculateResult() {
    _result = _amount * _rate;
  }

  Future<void> saveConversionToHistory() async {
    await _firestoreService.saveConversion(
      fromCurrency: _baseCurrency,
      toCurrency: _targetCurrency,
      fromAmount: _amount,
      toAmount: _result,
      rate: _rate,
    );
  }
}