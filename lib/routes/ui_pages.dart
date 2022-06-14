import 'package:flutter/cupertino.dart';

const String splashPath = '/splash';
const String loginPath = '/login';
const String createAccountPath = '/createAccount';
const String listItemsPath = '/listItems';
const String detailsPath = '/details';
const String cartPath = '/cart';
const String checkoutPath = '/checkout';
const String settingsPath = '/settings';

enum Pages {
  Splash,
  Login,
  CreateAccount,
  List,
  Details,
  Cart,
  Checkout,
  Settings
}

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;
  PageAction currentPageAction;

  PageConfiguration(
      {required this.key,
      required this.path,
      required this.uiPage,
      this.currentPageAction});
}

PageConfiguration splashPageConfig =
    PageConfiguration(key: 'Splash', path: splashPath, uiPage: Pages.Splash, currentPageAction: null);
PageConfiguration loginPageConfig =
    PageConfiguration(key: 'Login', path: loginPath, uiPage: Pages.Login, currentPageAction: null);
PageConfiguration createAccountPageConfig = PageConfiguration(
    key: 'CreateAccount', path: createAccountPath, uiPage: Pages.CreateAccount, currentPageAction: null);
PageConfiguration listItemsPageConfig = PageConfiguration(
    key: 'ListItems', path: listItemsPath, uiPage: Pages.List);
PageConfiguration detailsPageConfig =
    PageConfiguration(key: 'Details', path: detailsPath, uiPage: Pages.Details, currentPageAction: null);
PageConfiguration cartPageConfig =
    PageConfiguration(key: 'Cart', path: cartPath, uiPage: Pages.Cart, currentPageAction: null);
PageConfiguration checkoutPageConfig = PageConfiguration(
    key: 'Checkout', path: checkoutPath, uiPage: Pages.Checkout, currentPageAction: null);
PageConfiguration settingsPageConfig = PageConfiguration(
    key: 'Settings', path: settingsPath, uiPage: Pages.Settings, currentPageAction: null);
