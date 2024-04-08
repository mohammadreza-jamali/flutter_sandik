class Budget{
  double? budgetValue;
  String? budgetmonth;
  String? groupId;
  Budget();
  Budget.init({required this.budgetValue,required this.budgetmonth,required this.groupId});
   Map<String,dynamic> toMap()=>{
    "budgetValue":budgetValue,
    "budgetmonth":budgetmonth,
    "groupId":groupId
  };
  Budget fromJson(Map<String,dynamic> json){
    budgetValue=json["budgetValue"];
    budgetmonth=json["budgetmonth"];
    groupId=json["groupId"];
    return this;
  }
}