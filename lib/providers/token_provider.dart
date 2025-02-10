

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifytokenme/client/api_client.dart';
import 'package:audioplayers/audioplayers.dart';

import '../models/token_price_model.dart';


class TokenPriceNotifier extends AsyncNotifier<TokenPrice?> {
  Timer? timer;
  double lastPrice = 0;
  final  audioPlayer = AudioPlayer();

  @override
  Future<TokenPrice?> build() async {
    _startAutoRefresh();
    return APIClient().fetchTokenPrice();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final newPrice = await APIClient().fetchTokenPrice();
    if (newPrice != null) {
      _checkPriceChange(newPrice.value);
      lastPrice = newPrice.value;
    }
    state = AsyncValue.data(newPrice);
  }

  void _checkPriceChange(double newPrice) {
    if (lastPrice != null && lastPrice != newPrice) {
      _playSound();
    }
  }

  void _playSound() async {
    await audioPlayer.play(AssetSource("audios/notification.mp3"),volume: 100);
  }

  void _startAutoRefresh() {
    timer?.cancel(); // Cancela el Timer si ya existe
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      refresh();
    });
  }
}

final tokenPriceProvider =
AsyncNotifierProvider<TokenPriceNotifier, TokenPrice?>(() => TokenPriceNotifier());
