import 'package:token_traker/models/token.dart';
import 'package:token_traker/models/wallet.dart';
import 'package:token_traker/service/pvu_repository.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:web_scraper/web_scraper.dart';


class HttpPVURepository implements PVURepository{
  @override
  Future<Token> getPrice({String contract='0x31471e0791fcdbe82fbf4c44943255e923f1b794',network='BSC'}) async{
    var response = await http.get(Uri.parse(
        "https://api.pancakeswap.info/api/v2/tokens/${contract}"));
    Token data;
    if(response.statusCode == 200){
      Map<String, dynamic> body = convert.jsonDecode(response.body);

      data=Token.fromJson(body["data"],contract);
      return data;
    }else{
      return Token("BSC","","",0,0,"","","");
    }
  }
  @override
  Future<Token> getPriceBscScan({String contract='0x31471e0791fcdbe82fbf4c44943255e923f1b794',String network='BSC'})async{
    final webScraper = WebScraper(network=="BSC"?'https://bscscan.com':'https://etherscan.io/');
    print("Contrato: $contract");
    if( await webScraper.loadWebPage('/token/$contract')){
      var priceElement = webScraper.getElement('span.d-block>span[data-title]',['data-title']);
      var logoElement = webScraper.getElement('img.u-sm-avatar',['src']);
      var tokenNameElement = webScraper.getElement('div.media-body>span.text-secondary',['title']);
      var tokenSymbolElement = webScraper.getElement('div.col-md-8>b',['title']);
      var priceChangedLastDayElement = webScraper.getElement('span.d-block>span:nth-child(4)',['title']);

      num price=(priceElement.isNotEmpty)?num.parse(priceElement[0]['attributes']['data-title'].toString().split("\$")[1]):0.0;
      String imgUri=(logoElement.isNotEmpty)?"https://bscscan.com/"+logoElement[0]['attributes']['src']:"";
      String tokenName=(tokenNameElement.isNotEmpty)?tokenNameElement[0]['title']:'';
      String tokenSymbol=(tokenSymbolElement.isNotEmpty)?tokenSymbolElement[0]['title']:'';
      String priceChangeLastDay = (priceChangedLastDayElement.isNotEmpty)? priceChangedLastDayElement[0]['title']:'';
      return Token(network,tokenName, tokenSymbol,price.toDouble(),0.0,contract,imgUri,priceChangeLastDay);
    }else{
      return Token("BSC","", "", 0, 0, "", "","0.0%");
    }
  }
  @override
  Future<Wallet> getAddressInfo(String addressWallet,String network)async{
    String url=(network=="BSC")?'https://bscscan.com':'https://etherscan.io/';
    //String network="";
    String name="";
    String symbol="";
    double price=0.0;
    num balanceBnb=0.0;
    num bnbValue=0.0;
    List<Token> tokens=[];
    final webScraper = WebScraper(url);
    if( await webScraper.loadWebPage('/address/$addressWallet')){
      var tokensListElement = webScraper.getElement('ul.list-unstyled>li.list-custom-BEP-20', ['title']);
      List<Map<String, dynamic>> tokensLinkElement = webScraper.getElement('ul.list-unstyled>li.list-custom-BEP-20>a', ['href']);
      List<Map<String, dynamic>> tokensNameElement = webScraper.getElement('ul.list-unstyled>li.list-custom-BEP-20>a>div>div.d-flex>span.list-name>span[data-toggle]', ['title']);
      List<Map<String, dynamic>> tokensSymbolElement = webScraper.getElement('ul.list-unstyled>li.list-custom-BEP-20>a>div>div.d-flex>span.list-name', []);
      List<Map<String, dynamic>> tokensAmountlElement = webScraper.getElement('ul.list-unstyled>li.list-custom-BEP-20>a>div>span.list-amount', ['title']);
      List<Map<String, dynamic>> tokensUsdAmountlElement = webScraper.getElement(
          'ul.list-unstyled>li.list-custom-BEP-20>a>div.text-right>span.list-usd-value',
          ['title']);

      print("->"+tokensListElement.length.toString()+"|"+ tokensLinkElement.length.toString());
      print(tokensNameElement);
      print(tokensSymbolElement);
      return Wallet(network,name,symbol,price,balanceBnb,bnbValue,tokens);
    }
    return Wallet(network,name,symbol,price,balanceBnb,bnbValue,tokens);
  }
}