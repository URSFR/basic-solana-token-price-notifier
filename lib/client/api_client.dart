import 'package:http/http.dart' as http;
import 'package:notifytokenme/utils/string_constants.dart';

import '../models/token_price_model.dart';

class APIClient{
  Future<TokenPrice?> fetchTokenPrice() async {
    const url = 'https://public-api.birdeye.so/defi/price?include_liquidity=false&address=$SOLANA_TOKEN';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-API-KEY': API_KEY,
        'accept': 'application/json',
        'x-chain': 'solana',
      },
    );

    if (response.statusCode == 200) {
      return TokenPrice.fromRawJson(response.body);
    } else {
      return null; // Manejo de error
    }
  }
}

