import 'package:flutter/material.dart';
import 'package:flutter_sandik/model/category.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DefaultCategoryList extends StatelessWidget {
  final List<Category> defaultCategories;
  DefaultCategoryList(this.defaultCategories);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        physics: BouncingScrollPhysics(),
        itemCount: defaultCategories.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return CategoryListItem(
            item: defaultCategories[index],
          );
        });
  }
}

class CategoryListItem extends StatelessWidget {
  final Category item;

  const CategoryListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      width: 100,
      height: 90,
      decoration: BoxDecoration(
        color: Color(0xffBCDFFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Color.fromARGB(255, 19, 125, 157), blurRadius: 0.8)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.fromString(item.icon!),
            color: Color(0xff1F50D3),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            item.categoryName!,
            style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 11),
          )
        ],
      ),
    );
  }
}