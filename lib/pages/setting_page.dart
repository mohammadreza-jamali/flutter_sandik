import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/format_helper.dart';
import 'package:flutter_sandik/gen/assets.gen.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/pages/edit_user_setting.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/widgets/avatar_change_dialog.dart';
import 'package:flutter_sandik/widgets/user_info_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({required this.userId, super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
  final String userId;
}

class _SettingPageState extends State<SettingPage> {
  late AppUser? currentUser;
  ValueNotifier<bool> isLoaded = ValueNotifier(false);

  ValueNotifier<String?> currentAvatar = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff050119),
      appBar: AppBar(
        backgroundColor: Color(0xff050119),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    CupertinoIcons.arrow_left,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        title: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            'تنظیمات',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: isLoaded,
        builder: (BuildContext context, dynamic value, Widget? child) {
          if (!value)
            return Center(
              child: CircularProgressIndicator(),
            );

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25), gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.blue.shade200])),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: ValueListenableBuilder(
                              valueListenable: currentAvatar,
                              builder: (BuildContext context, String? value, Widget? child) {
                                if (value != null) {
                                  return Container(
                                    child: ClipRRect(
                                      child: Image.asset("assets/images/avatars/${value}.jpg"),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  );
                                }
                                return Icon(Icons.person, size: 80);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'پروفایل شما',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            SizedBox(
                              width: 200,
                              height: 30,
                              child: ElevatedButton(
                                onPressed: () async {
                                  var selectedAvatar = await showGeneralDialog<String?>(
                                    barrierDismissible: true,
                                    barrierLabel: "",
                                    context: context,
                                    pageBuilder: (context, animation, secondaryAnimation) => AvatarChangeDialog(currentAvatar.value),
                                  );
                                  currentAvatar.value = selectedAvatar;
                                  await updateUserAvatar();
                                },
                                child: Text('تغییر آواتار',style:TextStyle(color: Colors.blue.shade200)),
                                style: Theme.of(context).elevatedButtonTheme.style,
                              ),
                            )
                          ],
                        ),
                        //ElevatedButton(onPressed: (){}, child: Text('ویرایش'))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          FormatHelper.dateFormatter(currentUser!.formattedInsertDate),
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  UserInfoWidget(currentUser!)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void getUserInfo() async {
    isLoaded.value = false;
    var dbService = context.read<MTransaction>();
    currentUser = await dbService.getUserInfo(widget.userId);
    currentAvatar.value = currentUser?.avatarName;
    isLoaded.value = true;
  }

  updateUserAvatar() async {
    if (currentUser == null || currentAvatar.value == null) return;
    currentUser!.updateAvatar(currentAvatar.value!);
    var dbService = context.read<MTransaction>();
    await dbService.updateUser(currentUser!);
  }
}

class SettingItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final Function ontap;

  SettingItem({
    super.key,
    required this.icon,
    required this.text,
    required this.ontap,
  });

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.ontap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: Color(0xff202040),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              MdiIcons.chevronLeft,
              color: Colors.white,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    widget.icon,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Center(
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25), gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.blue.shade200])),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  child: ClipRRect(
                    child: Assets.images.avatars.avatar1.image(),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
