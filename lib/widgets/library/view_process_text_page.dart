import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/functions/function_dart';

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

  void _copyText(BuildContext context) async {
    if (processText.isNotEmpty) {
      await Clipboard.setData(
        ClipboardData(
          text: processText,
        ),
      );
      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "Text copied to clipboard",
      );
    }
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: subLandMarksCardBg,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
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
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'copy to clipboard',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () => _copyText(context),
                                icon: Icon(
                                  Icons.copy,
                                  size: 25,
                                  color: mainLandMarksColor,
                                ),
                              ),
                              SizedBox(
                                width: 5,
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
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}