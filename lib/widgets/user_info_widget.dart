import 'package:flutter/material.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:provider/provider.dart';

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget(this.user, {super.key});
  final AppUser user;

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  late TextEditingController nameController, lastNameController, countryController, cityController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    lastNameController = TextEditingController(text: widget.user.lastName);
    countryController = TextEditingController(text: widget.user.country);
    cityController = TextEditingController(text: widget.user.city);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  label: Text("Name"),
                  hintText: "Name",
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(
                  label: Text("Last Name"),
                  hintText: "Last Name",
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          decoration: InputDecoration(
            label: Text(widget.user.email!),
            hintText: widget.user.email,
          ),
          enabled: false,
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: countryController,
                decoration: InputDecoration(
                  label: Text("Country"),
                  hintText: "Country",
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  label: Text("city"),
                  hintText: "city",
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 32,
        ),
        Center(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await updateUser();
              },
              child: Text('ویرایش'),
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xff050119)),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  side: WidgetStatePropertyAll(BorderSide(color: Colors.blue.shade200, width: 2))),
            ),
          ),
        ),
      ],
    );
  }

  updateUser() async {
    var dbService = context.read<MTransaction>();
    var updateUser = await dbService.getUserInfo(widget.user.userId!);
    updateUser!.name = nameController.text;
    updateUser.lastName = lastNameController.text;
    updateUser.country = countryController.text;
    updateUser.city = cityController.text;

    await dbService.updateUser(updateUser);
  }
}
