import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final IconData? icon;
  final String? description;
  final bool showDescription;
  final Function()? onTap;
  const UserCard(
      {super.key,
      required this.name,
      this.imageUrl,
      this.icon,
      this.description,
      this.showDescription = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: TextButton(
        onPressed: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 5,
            ),
            CircleAvatar(
              radius: 25,
              child: ClipOval(
                child: imageUrl != null
                    ? Image(
                        image: NetworkImage(imageUrl!),
                      )
                    : icon != null
                        ? Icon(icon!)
                        : Text(name.substring(0, 2)),
              ),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200.0,
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 20.0),
                    ),
                  ),
                  SizedBox(height: 5),
                  Visibility(
                    visible: showDescription,
                    child: Text(
                      description ?? '',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    ;
  }
}
