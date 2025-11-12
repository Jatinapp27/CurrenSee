import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support")),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1605902711622-cfb43c4437d3?auto=format&fit=crop&w=1200&q=80',
            height: 180,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 24),
          Text(
            "Need Assistance?",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "We’re here to help you with your CurrenSee experience. "
                "You can contact our support team for help with login, currency data, or any app issues.",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 1,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.email_outlined, color: Colors.blueAccent),
              title: const Text("Email Support"),
              subtitle: const Text("support@currensee.app"),
              onTap: () {},
            ),
          ),
          Card(
            elevation: 1,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const ListTile(
              leading: Icon(Icons.forum_outlined, color: Colors.green),
              title: Text("Community Forum"),
              subtitle: Text("Join our user community for discussions."),
            ),
          ),
          Card(
            elevation: 1,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const ListTile(
              leading: Icon(Icons.question_answer_outlined, color: Colors.orange),
              title: Text("FAQ"),
              subtitle: Text("Find answers to frequently asked questions."),
            ),
          ),
        ],
      ),
    );
  }
}
