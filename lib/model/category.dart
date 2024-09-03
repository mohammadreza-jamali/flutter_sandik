

class Category{
  String? groupId;
  String? categoryId;
  String? categoryName;
  String? icon;
  bool? isDefault;

  Category();
  Category.init({required this.groupId,required this.categoryId,required this.categoryName,required this.icon, this.isDefault=false});

  Map<String,dynamic> toMap()=>{
    "groupId":groupId,
    "categoryId":categoryId,
    "categoryName" : categoryName,
    "isDefault" : isDefault,
    "icon" : icon
  };

  Category fromJson(Map<String,dynamic> json){
    groupId=json["groupId"];
    categoryId=json["categoryId"];
    categoryName=json["categoryName"];
    isDefault=json["isDefault"];
    icon=json["icon"];
    return this;
  }
}