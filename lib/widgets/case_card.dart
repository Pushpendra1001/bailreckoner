import 'package:flutter/material.dart';

class CaseCard extends StatelessWidget {
  final String caseNumber;
  final String prisonerName;
  final String status;
  final String date;
  final VoidCallback onTap;

  const CaseCard({
    super.key,
    required this.caseNumber,
    required this.prisonerName,
    required this.status,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      case 'under_review':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.2),
          child: Icon(Icons.folder, color: statusColor),
        ),
        title: Text(
          caseNumber,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(prisonerName),
            const SizedBox(height: 2),
            Text(date, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status.replaceAll('_', ' ').toUpperCase(),
            style: TextStyle(
              color: statusColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
