import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({required this.items,this.onChanged,this.icon,this.hintText=""});
  final Map<int,String> items;
  final String hintText;
  final Icon? icon;
  final Function? onChanged;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}
class _CustomDropdownState extends State<CustomDropdown> {
   int? selectedItem;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline( 
                child: DropdownButton2<int>(
                  isExpanded: true,
                  value: selectedItem,
                  alignment: AlignmentDirectional.centerEnd,
                  items:widget.items.entries.map<DropdownMenuItem<int>>((e) => DropdownMenuItem<int>(value: e.key,alignment: AlignmentDirectional.centerEnd,child: Text(e.value),),).toList(),
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
                  )
                 ),

                 selectedItemBuilder: (BuildContext context){return widget.items.entries.map<Row>((e) =>Row(
                    children: [
                      const SizedBox(width: 4,),
                      Text(e.value,style: const TextStyle(fontSize: 14),),
                    ],
                  )).toList();},
                 ),
              );
  }
}