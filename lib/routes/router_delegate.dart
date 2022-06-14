import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app_state.dart';
import '../ui/cart.dart';
import '../ui/checkout.dart';
import '../ui/create_account.dart';
import '../ui/details.dart';
import '../ui/list_items.dart';
import '../ui/login.dart';
import '../ui/settings.dart';
import '../ui/splash.dart';
import 'back_dispatcher.dart';
import 'ui_pages.dart';

class ShoppingRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  final List<MaterialPage> _pages = [];
  ShoppingBackButtonDispatcher? backButtonDispatcher;

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppState appState;

  ShoppingRouterDelegate(this.appState) : navigatorKey = GlobalKey() {
    appState.addListener(() {
      notifyListeners();
    });
  }

  /// Getter for a list that cannot be changed
  List<MaterialPage> get pages => List.unmodifiable(_pages);

  /// Number of pages function
  int numPages() => _pages.length;

  @override
  PageConfiguration get currentConfiguration =>
      _pages.last.arguments as PageConfiguration;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: buildPages(),
    );
  }

  bool _onPopPage(Route<dynamic> route, result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

  void _removePage(MaterialPage page) {
    _pages.remove(page);
  }

  void pop() {
    if (canPop()) {
      _removePage(_pages.last);
    }
  }

  bool canPop() {
    return _pages.length > 1;
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(_pages.last);
      return Future.value(true);
    }
    return Future.value(false);
  }

  MaterialPage _createPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
        child: child,
        key: ValueKey(pageConfig.key),
        name: pageConfig.path,
        arguments: pageConfig);
  }

  void _addPageData(Widget child, PageConfiguration pageConfig) {
    _pages.add(
      _createPage(child, pageConfig),
    );
  }

  void addPage(PageConfiguration? pageConfig) {
    final shouldAddPage = pageConfig != null && ( _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            pageConfig.uiPage);
    if (shouldAddPage) {
      switch (pageConfig.uiPage) {
        case Pages.Splash:
          _addPageData(const Splash(), splashPageConfig);
          break;
        case Pages.Login:
          _addPageData(const Login(), loginPageConfig);
          break;
        case Pages.CreateAccount:
          _addPageData(CreateAccount(), createAccountPageConfig);
          break;
        case Pages.List:
          _addPageData(ListItems(), listItemsPageConfig);
          break;
        case Pages.Cart:
          _addPageData(const Cart(), cartPageConfig);
          break;
        case Pages.Checkout:
          _addPageData(Checkout(), checkoutPageConfig);
          break;
        case Pages.Settings:
          _addPageData(Settings(), settingsPageConfig);
          break;
        case Pages.Details:
          if (pageConfig.currentPageAction != null && pageConfig.currentPageAction!.widget != null ) {
            _addPageData(pageConfig.currentPageAction!.widget!, pageConfig);
          }
          break;
        default:
          break;
      }
    }
  }

  void replace(PageConfiguration? newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(newRoute);
  }

  void setPath(List<MaterialPage> path) {
    _pages.clear();
    _pages.addAll(path);
  }

  void replaceAll(PageConfiguration? newRoute) {
    setNewRoutePath(newRoute);
  }

  void push(PageConfiguration newRoute) {
    addPage(newRoute);
  }

  void pushWidget(Widget child, PageConfiguration newRoute) {
    _addPageData(child, newRoute);
  }

  void addAll(List<PageConfiguration>? routes) {
    _pages.clear();
    if (routes != null) {
      for (var route in routes) {
      addPage(route);
    }
    }
    
  }

@override
  Future<void> setNewRoutePath(PageConfiguration? configuration) {

     final shouldAddPage = configuration != null && (_pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            configuration.uiPage);
    if (shouldAddPage) {
      _pages.clear();
      addPage(configuration);
    }
    return SynchronousFuture(null);
  }


  void _setPageAction(PageAction action) {

    switch (action.page?.uiPage) {
      case Pages.Splash:
        splashPageConfig.currentPageAction = action;
        break;
      case Pages.Login:
        loginPageConfig.currentPageAction = action;
        break;
      case Pages.CreateAccount:
        createAccountPageConfig.currentPageAction = action;
        break;
      case Pages.List:
        listItemsPageConfig.currentPageAction = action;
        break;
      case Pages.Cart:
        cartPageConfig.currentPageAction = action;
        break;
      case Pages.Checkout:
        checkoutPageConfig.currentPageAction = action;
        break;
      case Pages.Settings:
        settingsPageConfig.currentPageAction = action;
        break;
      case Pages.Details:
        detailsPageConfig.currentPageAction = action;
        break;
      default:
        break;
    }
  }

  List<Page> buildPages() {
    if (!appState.splashFinished) {
      replaceAll(splashPageConfig);
    } else {
      switch (appState.currentAction.state) {
        case PageState.none:
          break;
        case PageState.addPage:
          _setPageAction(appState.currentAction);
          addPage(appState.currentAction.page);
          break;
        case PageState.pop:
          pop();
          break;
        case PageState.replace:
          _setPageAction(appState.currentAction);
          replace(appState.currentAction.page);
          break;
        case PageState.replaceAll:
          _setPageAction(appState.currentAction);
          replaceAll(appState.currentAction.page);
          break;
        case PageState.addWidget:
        if(appState.currentAction.widget != null && appState.currentAction.page != null) {
          _setPageAction(appState.currentAction);
          pushWidget(appState.currentAction.widget!, appState.currentAction.page!);
        } 
        break;
        case PageState.addAll:
          addAll(appState.currentAction.pages);
          break;
      }
    }
    appState.resetCurrentAction();
    return List.of(_pages);
  }


  void parseRoute(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      setNewRoutePath(splashPageConfig);
      return;
    }

    // Handle navapp://deeplinks/details/#
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == 'details') {
        pushWidget(Details(int.parse(uri.pathSegments[1])), detailsPageConfig);
      }
    } else if (uri.pathSegments.length == 1) {
      final path = uri.pathSegments[0];
      switch (path) {
        case 'splash':
          replaceAll(splashPageConfig);
          break;
        case 'login':
          replaceAll(loginPageConfig);
          break;
        case 'createAccount':
          setPath([
            _createPage(const Login(), loginPageConfig),
            _createPage(CreateAccount(), createAccountPageConfig)
          ]);
          break;
        case 'listItems':
          replaceAll(listItemsPageConfig);
          break;
        case 'cart':
          setPath([
            _createPage(ListItems(), listItemsPageConfig),
            _createPage(const Cart(), cartPageConfig)
          ]);
          break;
        case 'checkout':
          setPath([
            _createPage(ListItems(), listItemsPageConfig),
            _createPage(Checkout(), checkoutPageConfig)
          ]);
          break;
        case 'settings':
          setPath([
            _createPage(ListItems(), listItemsPageConfig),
            _createPage(Settings(), settingsPageConfig)
          ]);
          break;
      }
    }
  }
}
