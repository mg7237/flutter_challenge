import "package:flutter/material.dart";
import "package:mgflutter/util/list_data.dart";

class GenderSelectField extends StatefulWidget {
  final Function userSelectedValue;
  final int initValue;
  GenderSelectField({this.userSelectedValue, this.initValue});

  @override
  _GenderSelectFieldState createState() => _GenderSelectFieldState();
}

class _GenderSelectFieldState extends State<GenderSelectField> {
  List<DropdownMenuItem> _itemMenuList = [];
  int _value = 0;

  getGenderData() {
    int i = 0;
    for (i = 0; i < gender.length; i++) {
      _itemMenuList.add(DropdownMenuItem(value: i, child: Text(gender[i])));
    }
    _value = widget.initValue;
    print("_vale ${_value}");
  }

  @override
  void initState() {
    super.initState();
    getGenderData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: _itemMenuList ?? [],
      value: _value,
      elevation: 12,
      icon: Icon(null),
      underline: Container(
          color: Color(0xFFBDBDBD), height: 1, width: double.infinity),
      hint: Text(
        "Please select your gender!      ",
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      onChanged: (newValue) {
        setState(() {
          _value = newValue;
          widget.userSelectedValue(newValue);
        });
      },
    );
  }
}
