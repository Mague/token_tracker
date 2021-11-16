import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:token_traker/models/token.dart';
import 'package:token_traker/service/http_pvu_repository.dart';

class Controller extends GetxController {
  final box = GetStorage();
  List<Token> _tokens = [];
  Map storageTokenList = {};
  bool get isDark => box.read('darkmode') ?? false;
  List<Token> get getTokens => _tokens;
  /* ThemeData(
    primarySwatch:Colors.blue,
    scaffoldBackgroundColor:Colors.blue[100]
  ) */
  ThemeData get theme => isDark ? ThemeData.dark() : ThemeData.light();
  void changeTheme(bool val) => box.write('darkmode', val);
  /* void setToken(String simbol,num price)=>box.write(simbol,price);
  Token getToken(String simbol) {
    var data=box.read(simbol);
    return Token(simbol,simbol,data,0);
  }  */
  void addAndStorageToken(Token token) {
    _tokens.add(token);
    final Map storageMap = {};
    storageMap['network'] = token.network;
    storageMap['name'] = token.name;
    storageMap['symbol'] = token.symbol;
    storageMap['price'] = token.price;
    storageMap['price_BNB'] = token.price_BNB;
    storageMap['contractAddress'] = token.contractAddress;
    storageTokenList[token.contractAddress] = storageMap;
    box.write('tokens', storageTokenList);
  }

  bool removeToken(String contract){
    storageTokenList = box.read("tokens") != null ? box.read("tokens"):{};
    if(storageTokenList.length>0){
      _tokens = [];
      storageTokenList.remove(contract);
      box.write('tokens', storageTokenList);
      return true;
    }
    return false;
  }
  Future<List<Token>> restoreTokens() async {
    //box.write('tokens',{});
    storageTokenList = box.read('tokens') != null ? box.read('tokens') : {};
    HttpPVURepository pvuRepository = HttpPVURepository();
    if (storageTokenList.length > 0) {
      _tokens = [];
      var storageMapEntries = storageTokenList.entries;
      for(int i=0;i<storageTokenList.entries.length;i++) {
          MapEntry tokenMap = storageMapEntries.elementAt(i);
          var token = tokenMap.key;
          var values = tokenMap.value;
          print(values);
          if(values['contractAddress'].length >0){
            Token tokenAux = await pvuRepository.getPriceBscScan(
                contract: values['contractAddress'],network: values['network']);
            /* final token = Token(value['name'], value['symbol'], value['price'],
              value['price_BNB'], value['contractAddress']); */
           // print(tokenAux.symbol);
            _tokens.add(tokenAux);
          
          }
      }
      /* storageTokenList.forEach((key, value) async {
        print("---->$key");
        Token tokenAux= await pvuRepository.getPriceBscScan(contract: value['contractAddress']);
        /* final token = Token(value['name'], value['symbol'], value['price'],
            value['price_BNB'], value['contractAddress']); */
        print(tokenAux.symbol);
        _tokens.add(tokenAux);
      }); */
      print(_tokens);
      return _tokens;
    }
    return _tokens;
  }

  void clearTokens() async {
    await box.remove('tokens');
  }

  void erase() async {
    await box.erase();
  }
}
