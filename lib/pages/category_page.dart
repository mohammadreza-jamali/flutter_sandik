import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/core/application/navigation_service.dart';
import 'package:flutter_sandik/gen/assets.gen.dart';
import 'package:flutter_sandik/model/category.dart';
import 'package:flutter_sandik/pages/data.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CategoryPage extends StatefulWidget {
  final String groupId;

  CategoryPage(this.groupId, {super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Category>? _categories;
  late MTransaction _transaction;

  @override
  Widget build(BuildContext context) {
    _transaction = Provider.of<MTransaction>(context, listen: true);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
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
                        Expanded(
                            child: FutureBuilder(
                          future: getCategories(true),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return DefaultCategoryList(snapshot.data!.where((category)=>category.isDefault==true).toList() ?? []);
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text("Error"));
                            }
                            return CircularProgressIndicator();
                          },
                        )),
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
                        _addCategoryBottomSheet(context, widget.groupId);
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
                      child: _transaction.state == ViewState.Idle
                          ? FutureBuilder(
                              future: getCategories(false),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return (snapshot.data!.where((category)=>category.isDefault==false).toList() ?? []).isNotEmpty
                                      ? CategoryGridView(snapshot.data!.where((category)=>category.isDefault==false).toList())
                                      : Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Assets.images.emptyPage
                                                      .image(),
                                                ),
                                              ),
                                              Text(
                                                'هنوز چیزی خرج نکردی !',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                'اولین خرجت رو اضافه کن.',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.grey.shade300),
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                              SizedBox(
                                                height: 32,
                                              )
                                            ],
                                          ),
                                        );
                                }
                                if (snapshot.hasError) {
                                  return Center(child: Text("Error"));
                                }
                                return CircularProgressIndicator();
                              },
                            )
                          : CircularProgressIndicator())),
            ],
          )),
    );
  }

  Future<List<Category>> getCategories(bool isDefault) async {
    return await _transaction.getCategories(widget.groupId, isDefault);
  }
}

class CategoryGridView extends StatelessWidget {
  final List<Category> favoriteCategories;
  CategoryGridView(this.favoriteCategories);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: favoriteCategories.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 1, maxCrossAxisExtent: 140, mainAxisExtent: 130),
        itemBuilder: (context, position) {
          return CategoryGridViewItem(
            item: favoriteCategories[position],
          );
        });
  }
}

class CategoryGridViewItem extends StatelessWidget {
  final Category item;
  const CategoryGridViewItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 150,
          height: 150,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xffBCDFFF),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 19, 125, 157), blurRadius: 0.8)
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(MdiIcons.fromString(item.icon!), color: Color(0xff1F50D3)),
              SizedBox(
                height: 16,
              ),
              Text(
                item.categoryName!,
                style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              )
            ],
          ),
        ),
        Positioned(
            top: 14,
            left: 14,
            child: InkWell(
              onTap: () async {
                var _transaction = context.read<MTransaction>();
                await _transaction.deleteCategory(item.categoryId!);
              },
              child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.red.shade300,
                      borderRadius: BorderRadius.circular(16)),
                  child: Icon(
                    MdiIcons.delete,
                    color: Colors.white,
                    size: 18,
                  )),
            ))
      ],
    );
  }
}

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

Future _addCategoryBottomSheet(BuildContext context, String groupId) {
  List<IconData> icons = MdiIcons.getIcons();
  TextEditingController categoryNameController = TextEditingController();
  late String selectedIcon;
  ValueNotifier<int> selectedIndex = ValueNotifier(-1);
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: categoryNameController,
                        decoration: InputDecoration(
                          label: Text(
                            'Category Name',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 24, 16),
                      child: Row(
                        children: [
                          Text(
                            'icon :',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                          itemCount: icons.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                selectedIcon = MdiIcons.getNames()[index];
                                selectedIndex.value = index;
                              },
                              child: ValueListenableBuilder(
                                valueListenable: selectedIndex,
                                builder: (BuildContext context, dynamic value,
                                    Widget? child) {
                                  return Container(
                                    color: value == index
                                        ? Colors.green
                                        : Colors.transparent,
                                    width: 40,
                                    height: 40,
                                    child: Icon(icons[index]),
                                  );
                                },
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
                        onPressed: () async {
                          var _transaction = context.read<MTransaction>();
                          await _transaction.addCategory(Category.init(
                              groupId: groupId,
                              categoryId: Uuid().v8(),
                              categoryName: categoryNameController.text,
                              icon: selectedIcon));
                        },
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
