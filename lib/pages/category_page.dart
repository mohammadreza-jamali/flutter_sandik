import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sandik/pages/data.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                'دسته بندی ها',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xff16398B)),
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 64, 18, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'دسته بندی های پیش فرض',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
                child: SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(child: CategoryList()),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        _addCategoryBottomSheet(context);
                      },
                      child: Text(
                        'افزودن دسته بندی',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500),
                      ),
                    ),
                    Text(
                      'دسته بندی های شما',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: CategoryGridView())),
            ],
          )),
    );
  }
}

class CategoryGridView extends StatelessWidget {
  const CategoryGridView();

  @override
  Widget build(BuildContext context) {
    final List<CategoryItem> myCategoryListItems =
        MyCategoryListItems.myCategoryListItems;
    return GridView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: myCategoryListItems.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 1, maxCrossAxisExtent: 140, mainAxisExtent: 130),
        itemBuilder: (context, position) {
          return CategoryGridViewItem(
            item: myCategoryListItems[position],
          );
        });
  }
}

class CategoryGridViewItem extends StatelessWidget {
  final CategoryItem item;
  const CategoryGridViewItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xffBCDFFF),
        boxShadow: [
          BoxShadow(color: Color.fromARGB(255, 19, 125, 157), blurRadius: 0.8)
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.categoryIcon, color: Color(0xff1F50D3)),
          SizedBox(
            height: 16,
          ),
          Text(
            item.categoryTitle,
            style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 12),
          )
        ],
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final List<CategoryItem> defualtCategoryList =
      DefualtCategoryList.defualtCategoryList;
  CategoryList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        physics: BouncingScrollPhysics(),
        itemCount: defualtCategoryList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return CategoryListItem(
            item: defualtCategoryList[index],
          );
        });
  }
}

class CategoryListItem extends StatelessWidget {
  final CategoryItem item;

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
            item.categoryIcon,
            color: Color(0xff1F50D3),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            item.categoryTitle,
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

Future _addCategoryBottomSheet(BuildContext context) {
  List<IconData> icons = MdiIcons.getIcons();
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          label: Text(
                            'Category Name',
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,16,24,16),
                      child: Row(
                        children: [
                          Text('icon :',style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    ),

                    Expanded(
                      child: GridView.builder(
                        itemCount: icons.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Container(
                                width: 40,
                                height: 40,
                                child: Icon(icons[index]),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 150,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'SAVE',
                          style: TextStyle(color: Colors.blue),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.indigo.shade50),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
      ));
}
