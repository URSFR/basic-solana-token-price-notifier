import 'dart:io';
import 'package:system_tray/system_tray.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifytokenme/providers/token_provider.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:window_manager/window_manager.dart';

class ShowScreen extends ConsumerWidget with WindowListener{
  const ShowScreen({super.key});

  @override
  void onWindowMinimize() {
    final AppWindow appWindow = AppWindow();
    appWindow.hide();

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    windowManager.addListener(this);
    initSystemTray(ref);



    final tokenPriceState = ref.watch(tokenPriceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Token Price")),
      body: Center(
        child: tokenPriceState.when(
          data: (tokenPrice) {
            if (tokenPrice == null) {
              return const Text("Error.");
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Price: \$${tokenPrice.value.toStringAsFixed(6)}"),
                Text("24h: ${tokenPrice.priceChange24h.toStringAsFixed(2)}%"),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text("Error: $err"),
        ),
      ),
    );
  }

  Future<void> initSystemTray(WidgetRef ref) async {
    String path =
    Platform.isWindows ? 'assets/images/app_icon.ico' : 'assets/app_icon.png';

    final AppWindow appWindow = AppWindow();
    final SystemTray systemTray = SystemTray();

    // We first init the systray menu
    await systemTray.initSystemTray(
      title: "system tray",
      iconPath: path,
    );

    // create context menu
    final Menu menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(label: 'Show', onClicked: (menuItem) => appWindow.show()),
      MenuItemLabel(label: 'Hide', onClicked: (menuItem) => appWindow.hide()),
      MenuItemLabel(label: 'Exit', onClicked: (menuItem) => appWindow.close()),
    ]);

    await systemTray.setTitle("TOKEN PRICE");
    await systemTray.setToolTip("PRICE ${ref.read(tokenPriceProvider.notifier).lastPrice.toString()}");

    // set context menu
    await systemTray.setContextMenu(menu);

    // handle system tray event
    systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick) {
        Platform.isWindows ? appWindow.show() : systemTray.popUpContextMenu();
      } else if (eventName == kSystemTrayEventRightClick) {
        Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.show();
      }
    });
  }

}
