import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _message = TextEditingController();
  bool _sending = false;

  Future<void> _sendFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulated send
    setState(() => _sending = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thank you for your feedback!")),
    );
    _message.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Send Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1556155092-8707de31f9c4?auto=format&fit=crop&w=1200&q=80',
              height: 160,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),
            Text(
              "We’d love to hear from you!",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Tell us what you like, dislike, or what we could improve in CurrenSee.",
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _message,
                decoration: const InputDecoration(
                  labelText: "Your Message",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (v) =>
                v != null && v.isNotEmpty ? null : "Please enter a message",
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.send),
                onPressed: _sending ? null : _sendFeedback,
                label: _sending
                    ? const Text("Sending...")
                    : const Text("Submit Feedback"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
