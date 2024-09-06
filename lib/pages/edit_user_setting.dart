import 'package:flutter/material.dart';

class EditUserSetting extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: TextDirection.rtl,
        children: [
          Text('نام و نام خانوادگی'),
          SizedBox(
            height: 8,
          ),
          TextField(
          ),
          Text('آدرس ایمیل'),
          SizedBox(
            height: 8,
          ),
          TextField(
          ),

          Text('شماره موبایل'),
          SizedBox(
            height: 8,
          ),
          TextField(
          ),
        ],
      ),
    );
  }
}