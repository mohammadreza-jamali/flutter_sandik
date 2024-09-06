import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/gen/assets.gen.dart';
import 'package:flutter_sandik/pages/edit_user_setting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          InkWell(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 16, 16, 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300)),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(CupertinoIcons.arrow_right),
              ),
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            'تنظیمات',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xff16398B)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ProfileAvatar(),
              SizedBox(
                height: 12,
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'کاربر صندوق',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'تاریخ عضویت 14 شهریور 1403',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'تنظیمات حساب کاربری',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 10,
              ),
              SettingItem(
                text: 'ویرایش حساب کاربر',
                icon: MdiIcons.account,
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditUserSetting()));
                },
              ),
              SizedBox(
                height: 8,
              ),
              SettingItem(
                  text: 'تغییر رمز عبور', icon: MdiIcons.lock, ontap: () {}),
              SizedBox(
                height: 8,
              ),
              SettingItem(
                  text: 'خروج از حساب کاربری',
                  icon: MdiIcons.homeExportOutline,
                  ontap: () {}),
              SizedBox(
                height: 14,
              ),
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'تنظیمات برنامه',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 10,
              ),
              SettingItem(text: 'زبان', icon: MdiIcons.translate, ontap: () {}),
              SizedBox(
                height: 8,
              ),
              SettingItem(
                  text: 'واحد پولی', icon: MdiIcons.currencyUsd, ontap: () {}),
              SizedBox(
                height: 8,
              ),
              SettingItem(
                  text: 'حالت تاریک',
                  icon: MdiIcons.themeLightDark,
                  ontap: () {}),
              SizedBox(
                height: 8,
              ),
              SettingItem(
                  text: 'درباره اپ',
                  icon: MdiIcons.informationSlabCircleOutline,
                  ontap: () {}),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
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
      onTap: widget.ontap(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              MdiIcons.chevronLeft,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(widget.icon),
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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.grey.shade300),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  child: ClipRRect(
                    child: Assets.images.icons.user
                        .svg(color: Colors.grey.shade500),
                    borderRadius: BorderRadius.circular(55),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue.shade900),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    MdiIcons.pencil,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
