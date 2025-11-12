import 'package:currensee_pkr/core/constants/currency_data.dart';
import 'package:flutter/material.dart';

class CurrencyListScreen extends StatefulWidget {
  final Function(String) onCurrencySelected;

  const CurrencyListScreen({super.key, required this.onCurrencySelected});

  @override
  State<CurrencyListScreen> createState() => _CurrencyListScreenState();
}

class _CurrencyListScreenState extends State<CurrencyListScreen> {
  String _searchQuery = '';
  Map<String, String> _filteredCurrencies = {};

  @override
  void initState() {
    super.initState();
    _filteredCurrencies = CurrencyData.currencies;
  }

  void _filterCurrencies(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCurrencies = CurrencyData.currencies;
      } else {
        _filteredCurrencies = Map.fromEntries(
          CurrencyData.currencies.entries.where(
                (entry) =>
            entry.key.toLowerCase().contains(query.toLowerCase()) ||
                entry.value.toLowerCase().contains(query.toLowerCase()),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Search by code or name...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: _filterCurrencies,
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredCurrencies.length,
        itemBuilder: (context, index) {
          final code = _filteredCurrencies.keys.elementAt(index);
          final name = _filteredCurrencies.values.elementAt(index);
          return ListTile(
            title: Text(code, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(name),
            onTap: () {
              widget.onCurrencySelected(code);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
