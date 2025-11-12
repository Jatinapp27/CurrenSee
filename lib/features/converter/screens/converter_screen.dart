import 'package:currensee_pkr/features/converter/providers/converter_provider.dart';
import 'package:currensee_pkr/features/currency_list/screens/currency_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConverterScreen extends StatelessWidget {
  const ConverterScreen({super.key});

  void _selectCurrency(BuildContext context, bool isBase) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CurrencyListScreen(
          onCurrencySelected: (currencyCode) {
            final provider =
            Provider.of<ConverterProvider>(context, listen: false);
            if (isBase) {
              provider.setBaseCurrency(currencyCode);
            } else {
              provider.setTargetCurrency(currencyCode);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<ConverterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.getConversionRate(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Input
            Text("Amount", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: "1.0",
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: theme.textTheme.headlineMedium,
              onChanged: (value) => provider.setAmount(value),
            ),
            const SizedBox(height: 24),

            // Currency Pickers
            Row(
              children: [
                _currencySelector(context, theme, "From", provider.baseCurrency, true),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.swap_horiz, size: 32, color: theme.colorScheme.primary),
                    onPressed: () => provider.swapCurrencies(),
                  ),
                ),
                _currencySelector(context, theme, "To", provider.targetCurrency, false),
              ],
            ),
            const SizedBox(height: 32),

            // Result
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              _buildResultUI(context, theme, provider),
          ],
        ),
      ),
    );
  }

  Widget _currencySelector(BuildContext context, ThemeData theme, String label, String currency, bool isBase) {
    return Expanded(
      child: InkWell(
        onTap: () => _selectCurrency(context, isBase),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currency,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                  const Icon(Icons.expand_more, color: Colors.grey)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultUI(BuildContext context, ThemeData theme, ConverterProvider provider) {
    return Center(
      child: Column(
        children: [
          Text("Converted Amount", style: theme.textTheme.titleMedium),
          Text(
            provider.result.toStringAsFixed(2),
            style: theme.textTheme.displayMedium
                ?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            '1 ${provider.baseCurrency} = ${provider.rate.toStringAsFixed(4)} ${provider.targetCurrency}',
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.save_alt),
            label: const Text('Save Conversion'),
            onPressed: () async {
              await provider.saveConversionToHistory();
              if (ScaffoldMessenger.of(context).mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Saved to History'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}