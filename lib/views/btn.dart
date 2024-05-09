import 'package:flutter/material.dart';

Widget buildCard({
  required dynamic price,
  required IconData icon,
  required String text,
  required context,
  required VoidCallback onPress,
}) {
  return InkWell(
    onTap: onPress,
    borderRadius: BorderRadius.circular(20),
    child: Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$price',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                const SizedBox(width: 10), // Adjust the spacing as needed
                Container(
                  width: 60, // Adjust the width of the circle as needed
                  height: 60, // Adjust the height of the circle as needed
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).textTheme.bodyText2!.color,
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1!.color,),
              ),
            ),
            Divider(
              color: Theme.of(context).textTheme.bodyText1!.color,
              thickness: 2, // Adjust the thickness of the line as needed
            ),
          ],
        ),
      ),
    ),
  );
}
