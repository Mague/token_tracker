import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:token_traker/controller/controller.dart';
import 'package:token_traker/pages/calculator/calculator.dart';
import 'package:token_traker/pages/token/add.dart';
import 'package:token_traker/pvu_repository.dart';
import 'package:token_traker/utils/parse.dart';
import 'models/token.dart';
import 'service/pvu_repository.dart';

void main() async{
  await GetStorage.init();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Controller controller = Get.put(Controller());
    
    return SimpleBuilder(builder: (_){
      return MaterialApp(
        title: 'BSC/ETH Token Tracker',
        theme: controller.theme,
        home: MyHomePage(title: 'Tokens',controller:controller),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title,required this.controller}) : super(key: key);

  final String title;
  final Controller controller;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Token> _tokens=[];

  void _incrementCounter() async {
    HttpPVURepository pvuRepository = HttpPVURepository();
    Token token = await pvuRepository.getPrice();
    //box = GetStorage();
   // widget.controller.setToken(token.symbol,token.price);

    setState(() {
      //_counter++;
      /* Token getToken=widget.controller.getToken(token.symbol);
      _token_price = getToken.price;
      _token_name = getToken.name; */
    });
  }
  dynamic _addTokenCB(String? name,String? symbol,String? contractAddress,String? network) async{
    print(name);
    print(symbol);
    print(contractAddress);
    HttpPVURepository pvuRepository = HttpPVURepository();
    Token token = await pvuRepository.getPriceBscScan(contract:contractAddress!,network:network!);
    //num tokenAux= await pvuRepository.getPriceBscScan(contract:contractAddress);
    if(token.name=='unknown'){
      token.name!=name;
    }
    if(token.symbol=='unknown'){
      token.symbol!=symbol;
    }
    //Token token = Token(name!, symbol!, 0.0, 0.0, contractAddress!);
    widget.controller.addAndStorageToken(token);
    setState(() {
      _tokens=widget.controller.getTokens;
      print(_tokens);
    });
  }
  void _addToken()async{
    final back = await Navigator.push(context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => AddToken(onSave: _addTokenCB),
      ), 
    );
  }
  void _showCalculator(Token token){
    Navigator.push(context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => CalculatorPage(token:token),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    /* widget.controller.box.erase();
    widget.controller.box.remove('tokens'); */
    
    HttpPVURepository pvuRepository = HttpPVURepository();
    pvuRepository.getAddressInfo("0xff94045d4c9a5d923e635bee0616d71e9972d605","BSC");
   /*  if(widget.controller.getTokens.length>0){
      setState(() {
        _tokens=widget.controller.getTokens;
      });
    } */
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: SwitchListTile(
                value: widget.controller.isDark,
                title: Text("Touch to change ThemeMode"),
                onChanged: widget.controller.changeTheme,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Token>>(
                future: widget.controller.restoreTokens(),
                builder: (context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData){
                    print(snapshot.data);
                    print(snapshot.data);
                    /* if(snapshot.data.length>0){
                      setState(() {
                        _tokens = snapshot.data!;
                      });
                    } */
                    return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final token = snapshot.data[index];
                            return Container(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.80,
                                    child: Card(
                                      child: ListTile(
                                        onTap: (){
                                          _showCalculator(token);
                                        },
                                        title: Text(token.name),
                                        subtitle: Row(
                                          children: [
                                            Text(
                                            token.price.toString() +
                                                " \$ "),
                                            SizedBox(
                                              width: 1.0,
                                            ),
                                            Text(token.symbol),
                                            Text(
                                              "${token.priceChange}",
                                              style: TextStyle(
                                                color: token.priceChange.toString().indexOf("+")!=-1?Colors.green:Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        leading: (token.imgUri == "")
                                          ?Icon(FontAwesomeIcons.bitcoin):
                                          Image.network(token.imgUri,width: 30,height: 30),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 1.0),
                                    alignment: Alignment.center,
                                    child:IconButton(
                                      tooltip: "Remove",
                                      alignment: Alignment.center,
                                      onPressed: ()async{
                                        var remove=widget.controller.removeToken(token.contractAddress);
                                        if(remove){
                                          
                                          var tokens=await widget.controller.restoreTokens();
                                          setState(() {
                                            _tokens=tokens;
                                          });
                                        }
                                      }, 
                                      icon: Icon(
                                        FontAwesomeIcons.trash,
                                        color: Colors.red
                                        )
                                      ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                  }
                  return Center(child:Text("No data"));
                }
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addToken,
        tooltip: 'Add Token',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
