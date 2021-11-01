import 'package:token_traker/models/token.dart';

abstract class PVURepository{
  Future<Token> getPrice();
}