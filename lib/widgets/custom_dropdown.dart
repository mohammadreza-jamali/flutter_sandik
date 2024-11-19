import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({required this.items,required this.selectedValue,this.onChanged,this.icon,this.hintText=""});
  final Map<int,String> items;
  final String hintText;
  final int selectedValue;
  final Icon? icon;
  final Function? onChanged;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}
class _CustomDropdownState extends State<CustomDropdown> {
   int? selectedItem;
   @override
   void initState() {
     super.initState();
     selectedItem=widget.selectedValue;
   }
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline( 
                child: DropdownButton2<int>(
                  isExpanded: true,
                  value: selectedItem,
                  alignment: AlignmentDirectional.centerEnd,
                  items:widget.items.entries.map<DropdownMenuItem<int>>((e) => DropdownMenuItem<int>(value: e.key,alignment: AlignmentDirectional.centerEnd,child: Text(e.value,style: TextStyle(color: Colors.black),),),).toList(),
                  hint: Row(
                    children: [
                      if(widget.icon!=null) widget.icon!,
                      SizedBox(width: 8,),
                      Text(widget.hintText,style: TextStyle(fontSize: 14,color: Colors.black),),
                    ],
                  ),
                 onChanged: (value){
                  setState((){
                    selectedItem=value;
                    if(widget.onChanged!=null)
                    {
                      widget.onChanged!(value);
                    }
                  });
                 },
                 buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                 ),
              
                 dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  )
                 ),

                 selectedItemBuilder: (BuildContext context){return widget.items.entries.map<Row>((e) =>Row(
                    children: [
                      const SizedBox(width: 4,),
                      Text(e.value,style: const TextStyle(fontSize: 14,color: Colors.black),),
                    ],
                  )).toList();},
                 ),
              );
  }
}

class GenericCustomDropdown<T> extends StatefulWidget {
  const GenericCustomDropdown({required this.items,this.onChanged,this.icon,this.hintText=""});
  final Map<T,String> items;
  final String hintText;
  final Icon? icon;
  final Function? onChanged;

  @override
  State<GenericCustomDropdown<T>> createState() => _GenericCustomDropdownState<T>();
}
class _GenericCustomDropdownState<T> extends State<GenericCustomDropdown<T>> {
   T? selectedItem;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline( 
                child: DropdownButton2<T>(
                  isExpanded: true,
                  value: selectedItem,
                  alignment: AlignmentDirectional.centerEnd,
                  items:widget.items.entries.map<DropdownMenuItem<T>>((e) => DropdownMenuItem<T>(value: e.key,alignment: AlignmentDirectional.centerEnd,child: Text(e.value,),),).toList(),
                  hint: Row(
                    children: [
                      if(widget.icon!=null) widget.icon!,
                      SizedBox(width: 8,),
                      Text(widget.hintText,style: TextStyle(fontSize: 14),),
                    ],
                  ),
                 onChanged: (value){
                  setState((){
                    selectedItem=value;
                    if(widget.onChanged!=null)
                    {
                      widget.onChanged!(value);
                    }
                  });
                 },
                 buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                 ),
              
                 dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade300
                  )
                 ),
                 menuItemStyleData: MenuItemStyleData(
                  overlayColor: WidgetStatePropertyAll(Colors.grey.shade300),
                 ),

                 selectedItemBuilder: (BuildContext context){return widget.items.entries.map<Row>((e) =>Row(
                    children: [
                      const SizedBox(width: 4,),
                      Text(e.value,style: const TextStyle(fontSize: 14,),),
                    ],
                  )).toList();},
                 ),
              );
  }
}