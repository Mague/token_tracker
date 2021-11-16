import 'package:token_traker/models/token.dart';
import 'package:token_traker/models/wallet.dart';

abstract class PVURepository{
  Future<Token> getPrice();
  Future<Token> getPriceBscScan({String contract,String network});
  Future<Wallet> getAddressInfo(String addressWallet,String network);
}