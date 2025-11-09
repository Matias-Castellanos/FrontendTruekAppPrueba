import 'package:flutter/material.dart';
import '../presentation/wallet/wallet.dart';
import '../presentation/messages/messages.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/item_detail/item_detail.dart';
import '../presentation/marketplace_home/marketplace_home.dart';
import '../presentation/add_item/add_item.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String wallet = '/wallet';
  static const String messages = '/messages';
  static const String login = '/login-screen';
  static const String itemDetail = '/item-detail';
  static const String marketplaceHome = '/marketplace-home';
  static const String addItem = '/add-item';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const MarketplaceHome(),
    wallet: (context) => const Wallet(),
    messages: (context) => const Messages(),
    login: (context) => const LoginScreen(),
    itemDetail: (context) => const ItemDetail(),
    marketplaceHome: (context) => const MarketplaceHome(),
    addItem: (context) => const AddItem(),
    // TODO: Add your other routes here
  };
}
