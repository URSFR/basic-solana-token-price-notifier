import 'dart:convert';

class TokenPrice {
  final double value;
  final int updateUnixTime;
  final String updateHumanTime;
  final double priceChange24h;
  final bool success;

  TokenPrice({
    required this.value,
    required this.updateUnixTime,
    required this.updateHumanTime,
    required this.priceChange24h,
    required this.success,
  });

  factory TokenPrice.fromJson(Map<String, dynamic> json) {
    return TokenPrice(
      value: json['data']['value'].toDouble(),
      updateUnixTime: json['data']['updateUnixTime'],
      updateHumanTime: json['data']['updateHumanTime'],
      priceChange24h: json['data']['priceChange24h'].toDouble(),
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": {
        "value": value,
        "updateUnixTime": updateUnixTime,
        "updateHumanTime": updateHumanTime,
        "priceChange24h": priceChange24h,
      },
      "success": success,
    };
  }

  static TokenPrice fromRawJson(String str) => TokenPrice.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}
