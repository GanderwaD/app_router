import 'package:flutter/material.dart';
import 'ui_pages.dart';

class ShoppingParser extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');
    if (uri.pathSegments.isEmpty) {
      return splashPageConfig;
    }

    final path = '/${uri.pathSegments[0]}';
    switch (path) {
      case splashPath:
        return splashPageConfig;
      case loginPath:
        return loginPageConfig;
      case createAccountPath:
        return createAccountPageConfig;
      case listItemsPath:
        return listItemsPageConfig;
      case detailsPath:
        return detailsPageConfig;
      case cartPath:
        return cartPageConfig;
      case checkoutPath:
        return checkoutPageConfig;
      case settingsPath:
        return settingsPageConfig;
      default:
        return splashPageConfig;
    }
  }

  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    switch (configuration.uiPage) {
      case Pages.Splash:
        return const RouteInformation(location: splashPath);
      case Pages.Login:
        return const RouteInformation(location: loginPath);
      case Pages.CreateAccount:
        return const RouteInformation(location: createAccountPath);
      case Pages.List:
        return const RouteInformation(location: listItemsPath);
      case Pages.Details:
        return const RouteInformation(location: detailsPath);
      case Pages.Cart:
        return const RouteInformation(location: cartPath);
      case Pages.Checkout:
        return const RouteInformation(location: checkoutPath);
      case Pages.Settings:
        return const RouteInformation(location: settingsPath);
      default: return const RouteInformation(location: splashPath);

    }
  }
}