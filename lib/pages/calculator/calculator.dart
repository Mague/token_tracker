import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:token_traker/models/token.dart';
import 'package:token_traker/utils/parse.dart';
import 'package:token_traker/widgets/field.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key? key,required this.token}) : super(key: key);
  final Token token;  
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  num _tokenAmount = 0;
  num _total = 0.0;
  num _rounding=0.0;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Token'),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  if (widget.token.imgUri == "")
                  Icon(FontAwesomeIcons.bitcoin),
                  if(widget.token.imgUri!="")
                  Image.network(widget.token.imgUri,width: 30,height: 30),
                  SizedBox(
                    height: 15,
                  ),
                  Text("${widget.token.name}: ${widget.token.price}\$"),
                  Text("${currencyFormat(widget.token.price.toDouble())}BNB"),
                  SizedBox(
                    height: 15,
                  ),
                  field(textTheme, true, '0.0',TextInputType.number ,FontAwesomeIcons.dollarSign,
                      //onChanged
                      (value)  {
                        print("Cambiando: ${value}");
                        num val=num.parse(value);
                        calculate(val);
                      },
                      (value) {
                        _tokenAmount = num.parse(value!);
                  }),
                  /* field(textTheme,true,'Rounding: Example 10',TextInputType.number,FontAwesomeIcons.autoprefixer,
                    (value){
                      //_rounding=num.parse(value);
                      print("NUEVO PRECIO: ${num.parse(value) * widget.token.price.toDouble()}");
                      print(Decimal.parse(widget.token.price.toString()));
                      //calculate(_rounding*_tokenAmount);
                      setState(() {
                        //_rounding=num.parse(value);
                      });
                    },
                    (value){

                  }), */
                  SizedBox(
                    height: 15,
                  ),
                  Text("Total amount: ${currencyFormat(_total.toDouble())}\$")
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Token',
        child: Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            print("$_tokenAmount");
            //widget.onSave(_name, _symbol, _contractAddress);

            Navigator.pop(context);
          }
        },
      ),
    );
  }

  void calculate(num val) {
    setState(() {
      if(val>0){
        _tokenAmount = val;
        _total = widget.token.price * _tokenAmount;
        print(_total);
        print("Total: ${currencyFormat(_total.toDouble())}");
      }
    });
  }
}