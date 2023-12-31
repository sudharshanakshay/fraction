import 'package:flutter/cupertino.dart';

class IconAndDetail extends StatelessWidget {
  const IconAndDetail(this.icon, this.detail, {super.key});
  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              detail,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      );
}

class DetailAndIcon extends StatelessWidget {
  const DetailAndIcon(this.icon, this.detail, {super.key});
  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              detail,
              style: const TextStyle(fontSize: 18),
            ),
            Icon(icon),
            const SizedBox(width: 8),
          ],
        ),
      );
}
