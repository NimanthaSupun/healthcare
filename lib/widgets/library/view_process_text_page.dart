
import 'package:flutter/material.dart';

class ViewProcessTextPage extends StatelessWidget {
  final String title;
  final String processText;

  const ViewProcessTextPage({
    super.key,
    required this.title,
    required this.processText,
  });

  List<TextSpan> _formatContractText(String text) {
    // Split into sections based on numbered points
    final sections = text.split(RegExp(r'(?=\d+\.)'));

    return sections.map((section) {
      // Identify headers/titles (assuming they end with ":")
      if (section.trim().endsWith(':')) {
        return TextSpan(
          text: '${section.trim()}\n\n',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.5,
          ),
        );
      }

      // Format numbered points
      if (RegExp(r'^\d+\.').hasMatch(section.trim())) {
        return TextSpan(
          text: '${section.trim()}\n\n',
          style: const TextStyle(
            fontSize: 16,
            height: 1.8,
            fontWeight: FontWeight.bold,
          ),
        );
      }

      // Regular paragraphs
      return TextSpan(
        text: '${section.trim()}\n\n',
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey[50],
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Document metadata section
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.description_outlined,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Legal Document',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Main content
                          SelectableText.rich(
                            TextSpan(
                              children: _formatContractText(processText),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom padding
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
