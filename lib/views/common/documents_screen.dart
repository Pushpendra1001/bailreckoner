import 'package:flutter/material.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final documents = [
      {
        'title': 'Identity Proof',
        'items': ['Aadhaar Card', 'PAN Card', 'Passport', 'Voter ID'],
        'icon': Icons.badge,
      },
      {
        'title': 'Residence Proof',
        'items': [
          'Aadhaar Card',
          'Utility Bills',
          'Rent Agreement',
          'Property Documents',
        ],
        'icon': Icons.home,
      },
      {
        'title': 'Case Documents',
        'items': [
          'FIR Copy',
          'Charge Sheet',
          'Previous Court Orders',
          'Arrest Warrant',
        ],
        'icon': Icons.gavel,
      },
      {
        'title': 'Financial Documents',
        'items': [
          'Income Certificate',
          'Bank Statements',
          'Property Papers',
          'ITR',
        ],
        'icon': Icons.account_balance,
      },
      {
        'title': 'Character References',
        'items': [
          'Employment Letter',
          'Community Leader Statement',
          'Family Details',
          'Medical Records',
        ],
        'icon': Icons.people,
      },
      {
        'title': 'Sureties Documents',
        'items': [
          'Surety Affidavit',
          'Surety Identity Proof',
          'Surety Property Documents',
          'Surety Income Proof',
        ],
        'icon': Icons.handshake,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Required Documents')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = constraints.maxWidth > 600 ? 24.0 : 16.0;
            return ListView(
              padding: EdgeInsets.all(padding),
              children: [
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Keep these documents ready for a smooth bail application process',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...documents.map(
                  (doc) => _DocumentCategory(
                    title: doc['title'] as String,
                    items: doc['items'] as List<String>,
                    icon: doc['icon'] as IconData,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DocumentCategory extends StatelessWidget {
  final String title;
  final List<String> items;
  final IconData icon;

  const _DocumentCategory({
    required this.title,
    required this.items,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${items.length} documents'),
          children: items
              .map(
                (item) => ListTile(
                  leading: const Icon(Icons.check_circle_outline, size: 20),
                  title: Text(item),
                  dense: true,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
