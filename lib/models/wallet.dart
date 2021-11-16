import 'package:token_traker/models/token.dart';

class Wallet {
  final String network;
  final String name;
  final String symbol;
  final double price;
  final num balanceBnb;
  final num bnbValue;
  final List<Token> tokens;
  Wallet(this.network, this.name, this.symbol, this.price, this.balanceBnb,
      this.bnbValue, this.tokens);

  
  Map<String, dynamic> toJson() => {
        'network': network,
        'name': name,
        'symbol': symbol,
        'price': price,
        'balanceBnb': balanceBnb,
        'bnbValue': bnbValue,
        'tokens': tokens,
      };
}
