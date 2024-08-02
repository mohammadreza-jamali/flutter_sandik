import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Cost{
  final String groupName;
  final String date;
  final String price;
  final IconData groupIcon;
  final int bankId;

  Cost({required this.groupName, required this.date, required this.price, required this.groupIcon, required this.bankId});
}



class FakeCostList{
  static List<Cost> get costs{
   return [
    Cost(groupName: 'اینترنت', date: '22 اردیبهشت 1403-00:36', price: '29,000', groupIcon: MdiIcons.web, bankId: 1),
    Cost(groupName: 'خرید های خانه', date: '21 اردیبهشت 1403-19:43', price: '156,000', groupIcon: Icons.home, bankId: 2),
    Cost(groupName: 'غذا و خوراک', date: '21 اردیبهشت 1403-18:45', price: '228,000', groupIcon: MdiIcons.food, bankId:2),
    Cost(groupName: 'آرایشگاه', date: '19 اردیبهشت 1403-22:22', price: '120,000', groupIcon: Icons.cut, bankId: 2),
    Cost(groupName: 'اینترنت', date: '19 اردیبهشت 1403-20:45', price: '29,000', groupIcon: MdiIcons.web, bankId: 2),
    Cost(groupName: 'حمل و نقل', date: '19 اردیبهشت 1403-16:00', price: '22,000', groupIcon: MdiIcons.carSide, bankId: 2),
    Cost(groupName: 'آرایشگاه', date: '19 اردیبهشت 1403-22:22', price: '120,000', groupIcon: Icons.cut, bankId: 2),
    Cost(groupName: 'اینترنت', date: '19 اردیبهشت 1403-20:45', price: '29,000', groupIcon: MdiIcons.web, bankId: 2),
    Cost(groupName: 'حمل و نقل', date: '19 اردیبهشت 1403-16:00', price: '22,000', groupIcon: MdiIcons.carSide, bankId: 2),
    Cost(groupName: 'آرایشگاه', date: '19 اردیبهشت 1403-22:22', price: '120,000', groupIcon: MdiIcons.contentCut, bankId: 2),
    Cost(groupName: 'اینترنت', date: '19 اردیبهشت 1403-20:45', price: '29,000', groupIcon: MdiIcons.web, bankId: 2),
    Cost(groupName: 'حمل و نقل', date: '19 اردیبهشت 1403-16:00', price: '22,000', groupIcon: MdiIcons.carSide, bankId: 2),

   ]; 
  }
}


class CategoryItem{
  final IconData categoryIcon;
  final String categoryTitle;

  CategoryItem({required this.categoryIcon, required this.categoryTitle});
}

class DefualtCategoryList{
  static List<CategoryItem> get defualtCategoryList{
    return [
      CategoryItem(categoryIcon: MdiIcons.food, categoryTitle: 'غذا و خوراک'),
      CategoryItem(categoryIcon: MdiIcons.tshirtCrew, categoryTitle: 'لباس و پوشاک'),
      CategoryItem(categoryIcon: MdiIcons.carSide, categoryTitle: 'حمل و نقل'),
      CategoryItem(categoryIcon: MdiIcons.cellphone, categoryTitle: 'قبض موبایل'),
    ];
  }
}

class MyCategoryListItems{
  static List<CategoryItem> get myCategoryListItems{
    return [
      CategoryItem(categoryIcon: MdiIcons.cellphone, categoryTitle: 'قبض موبایل'),
      CategoryItem(categoryIcon: MdiIcons.hammerScrewdriver, categoryTitle: 'وسایل و ابزار'),
      CategoryItem(categoryIcon: MdiIcons.laptop, categoryTitle: 'وسایل الکترونیکی'),
      CategoryItem(categoryIcon: MdiIcons.earbudsOutline, categoryTitle: 'موزیک'),
      CategoryItem(categoryIcon: MdiIcons.account, categoryTitle: 'بابا'),
      CategoryItem(categoryIcon: MdiIcons.contentCut, categoryTitle: 'آرایشگاه'),
      CategoryItem(categoryIcon: MdiIcons.wifi, categoryTitle: 'VPN'),
      CategoryItem(categoryIcon: MdiIcons.web, categoryTitle: 'اینترنت'),
    ];
  }
}


class Group{
final String groupName;
final List asignedMembers;

  Group({required this.groupName, required this.asignedMembers});
}