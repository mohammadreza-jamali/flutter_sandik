import 'package:flutter/material.dart';

class AvatarChangeDialog extends StatefulWidget {
  const AvatarChangeDialog(this.currentAvatar, {super.key});
  final String? currentAvatar;

  @override
  State<AvatarChangeDialog> createState() => _AvatarChangeDialogState();
}

class _AvatarChangeDialogState extends State<AvatarChangeDialog> {
  String? selectedAvatar;
  @override
  void initState() {
    super.initState();
    selectedAvatar = widget.currentAvatar;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / 3,
        child: GridView.count(
          crossAxisCount: 3,
          children: getAvatars(),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pop(selectedAvatar);
            },
            icon: Icon(
              Icons.check,
              color: Colors.green,
            ))
      ],
    );
  }

  getAvatars() {
    return List<Widget>.generate(
        6,
        (index) => InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                selectedAvatar = "avatar${index + 1}";
                setState(() {});
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, border: Border.all(color: "avatar${index + 1}" == selectedAvatar ? Colors.blue : Colors.transparent, width: 2)),
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/avatars/avatar${index + 1}.jpg"),
                ),
              ),
            ));
  }
}
