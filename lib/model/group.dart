class Group{
  String? groupId;
  String? groupName;
  List<dynamic>? groupUsers;
  String? groupAdmin;
  Group();
  Group.init({required this.groupId,this.groupName,this.groupUsers,this.groupAdmin});
   Map<String,dynamic> toMap()=>{
    "groupId":groupId,
    "groupName":groupName,
    "groupUsers":groupUsers,
    "groupAdmin":groupAdmin
  };
  Group fromJson(Map<String,dynamic> json){
    groupId=json["groupId"];
    groupName=json["groupName"];
    groupUsers=json["groupUsers"];
    groupAdmin=json["groupAdmin"];
    return this;
  }
}