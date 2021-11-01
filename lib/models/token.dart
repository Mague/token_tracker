class Token {
  final String name;
  final String network;
  final String symbol;
  final double price;
  final num price_BNB;
  final String contractAddress;
  final String imgUri;
  final String priceChange;
  Token(this.network,this.name, this.symbol, this.price, this.price_BNB,this.contractAddress,this.imgUri,this.priceChange);

  Token.fromJson(Map<String,dynamic> json,String contractAddress):
    network = json['network'],
    name = json['name'],
    contractAddress = contractAddress,
    symbol = json['symbol'],
    imgUri = '',
    priceChange = '0.0%',
    price = double.parse(json['price']),
    price_BNB = num.parse(json['price_BNB']);
  
   Map<String, dynamic> toJson() => {
        'network': network,
        'name': name,
        'symbol': symbol,
        'price': price,
        'imgUri': imgUri,
        'contractAddress': contractAddress,
        'price_BNB': price_BNB,
        'priceChange': priceChange,
      };
}