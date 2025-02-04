import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class CategoryBottonSheet extends StatelessWidget {
  final VoidCallback deleteCallback;
  final VoidCallback editCallback;
  const CategoryBottonSheet({
    super.key,
    required this.deleteCallback,
    required this.editCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Delete Category",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: deleteCallback,
                  icon: Icon(
                    Icons.delete,
                    size: 25,
                    color: mainOrangeColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Edit Category",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: editCallback,
                  icon: Icon(
                    Icons.edit,
                    size: 25,
                    color: button1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
