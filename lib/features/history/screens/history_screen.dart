import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currensee_pkr/data/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();
    final DateFormat formatter = DateFormat('MMM dd, yyyy  hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversion History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getConversionHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No history found.'));
          }

          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                child: ListTile(
                  title: Text(
                    '${data['fromAmount']} ${data['fromCurrency']} ➔ ${data['toAmount'].toStringAsFixed(2)} ${data['toCurrency']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      'Rate: 1 ${data['fromCurrency']} = ${data['rate']} ${data['toCurrency']}'),
                  trailing: Text(
                    timestamp != null ? formatter.format(timestamp) : '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}