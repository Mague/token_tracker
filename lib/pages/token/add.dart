import 'package:flutter/material.dart';
import 'package:token_traker/widgets/field.dart';

typedef OnSaveCallback = Function(String? name,String? symbol,String? contractAddress,String? network);
class AddToken extends StatefulWidget {
  AddToken({Key? key,required this.onSave}) : super(key: key);
  final OnSaveCallback onSave;
  @override
  _AddTokenState createState() => _AddTokenState();
}

class _AddTokenState extends State<AddToken> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _name,_symbol,_contractAddress;
  String _network="BSC";
  @override
  Widget build(BuildContext context) {
    final textTheme=Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title:Text('Add Token'),
      ),
      body: Padding(
        padding:EdgeInsets.all(16.0),
        child:Form(
          key:_formKey,
          child:ListView(
            children: [
              Center(
                child: SwitchListTile(
                  value: (_network=="BSC")?false:true,
                  title: Text("Network: $_network"),
                  onChanged: (val){
                    print(val);
                    setState(() {
                      _network=(_network=="BSC")?"ETH":"BSC";
                    });
                  },
                ),
              ),
              field(textTheme,true,'',null,Icons.text_fields,null,
                      (value) => _name = value),
              SizedBox(height: 15,),
              field(textTheme,true,'PVU',null,Icons.text_fields,null,
                      (value) => _symbol = value),
              SizedBox(height: 15,),
              field(textTheme,true,'0x...3434',null,Icons.text_fields,null,
                      (value) => _contractAddress = value),
            ],
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        tooltip:'Add Token',
        child: Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            print("$_name $_symbol $_contractAddress");
            widget.onSave(_name,_symbol,_contractAddress,_network);

            Navigator.pop(context);
          }
        },
      ),
    );
  }

}