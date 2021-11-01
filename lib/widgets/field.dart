import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextFormField field(TextTheme textTheme, bool autofocus, String hintText,TextInputType? inputType,
    IconData icon, void Function(String)? onChanged,void Function(String?)? onSaved) {
  return TextFormField(
    initialValue: '',
    autofocus: autofocus ? true : false,
    style: textTheme.headline5,
    onChanged: onChanged,
    decoration: InputDecoration(
        hintText: hintText != '' ? hintText : 'Plant vs Undead',
        prefixIcon: icon != null ? Icon(icon) : null),
        keyboardType: inputType!=null?inputType:TextInputType.text,
        inputFormatters: [
          (inputType!=null && inputType==TextInputType.number)
            ?
            FilteringTextInputFormatter.digitsOnly
            :
            FilteringTextInputFormatter.singleLineFormatter
        ],
    validator: (val) {
      return val!.trim().isEmpty ? 'Required field' : null;
    },
    //onSaved: (value)=> varS =value,
    onSaved: onSaved,
  );
}
