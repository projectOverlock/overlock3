import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:overlock/ui/WritePage.dart';
import 'package:overlock/ui/moreInforNewUser.dart';
import 'package:overlock/ui/reset.dart';
import 'package:overlock/ui/sowon/WriteSoWon.dart';
import 'package:overlock/ui/userInfo/AgreePage.dart';
import 'package:overlock/ui/userInfo/FirstCorpSelect.dart';
import 'package:overlock/ui/userInfo/FirstDatePick.dart';
import 'package:overlock/ui/userInfo/FirstLevelSelect.dart';
import 'package:overlock/ui/userInfo/FirstMilSelect.dart';
import 'package:overlock/ui/userInfo/LevelSelector.dart';
import 'package:overlock/ui/userInfo/MilSelector.dart';
import 'package:overlock/ui/userInfo/datePicker.dart';
import 'package:overlock/ui/userInfo/moreInformation.dart';
import 'package:overlock/ui/userInfo/nickNameChange.dart';
import 'package:overlock/ui/userInfo/settings.dart';
import '../app_state.dart';
import '../ui/details.dart';
import '../ui/cart.dart';
import '../ui/checkout.dart';
import '../ui/create_account.dart';
import '../ui/list_items.dart';
import '../ui/login.dart';
import '../ui/splash.dart';
import 'back_dispatcher.dart';
import 'ui_pages.dart';

class ShoppingRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  final List<Page> _pages = [];
  ShoppingBackButtonDispatcher backButtonDispatcher;

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
    if (page != null) {
      _pages.remove(page);
    }
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

  void addPage(PageConfiguration pageConfig) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            pageConfig.uiPage;
    if (shouldAddPage) {
      switch (pageConfig.uiPage) {
        case Pages.Splash:
          _addPageData(Splash(), SplashPageConfig);
          break;
        case Pages.Login:
          _addPageData(Login(), LoginPageConfig);
          break;
        case Pages.CreateAccount:
          _addPageData(CreateAccount(), CreateAccountPageConfig);
          break;
        case Pages.ListItems:
          _addPageData(ListItems(), ListItemsPageConfig);
          break;
        case Pages.Cart:
          _addPageData(Cart(), CartPageConfig);
          break;
        case Pages.Checkout:
          _addPageData(Checkout(), CheckoutPageConfig);
          break;
        case Pages.Settings:
          _addPageData(SettingsState(), SettingsPageConfig);
          break;
        case Pages.WriteSoWon:
          _addPageData(writeSoWon(), SettingsPageConfig);
          break;
        case Pages.AgreePage:
          _addPageData(agreePage(), SettingsPageConfig);
          break;
        case Pages.MoreinforNewUser:
          _addPageData(moreInforNewUser(), SettingsPageConfig);
          break;

        case Pages.WritnickNameChange:
          _addPageData(nickNameChange(), SettingsPageConfig);
          break;
        case Pages.levelSelector:
          _addPageData(levelSelector(), SettingsPageConfig);
          break;
        case Pages.milSelector:
          _addPageData(milSelector(), SettingsPageConfig);
          break;
        case Pages.moreInformation:
          _addPageData(moreInformation(), SettingsPageConfig);
          break;
        case Pages.datePicker:
          _addPageData(datePicker(), SettingsPageConfig);
          break;

        case Pages.ResetScreen:
          _addPageData(ResetScreen(), SettingsPageConfig);
          break;
        case Pages.FirstDatePick:
          _addPageData(FirstDatePick(), SettingsPageConfig);
          break;
        case Pages.FirstLevelSelect:
          _addPageData(FirstLevelSelect(), SettingsPageConfig);
          break;
        case Pages.FirstMilSelect:
          _addPageData(FirstMilSelect(), SettingsPageConfig);
          break;
        case Pages.FirstCorpSelect:
          _addPageData(FirstCorpSelect(), SettingsPageConfig);
          break;

        case Pages.WritePage:
          if (pageConfig.currentPageAction != null) {
            _addPageData(pageConfig.currentPageAction.widget, pageConfig);
          }
          break;
        case Pages.Details:
          if (pageConfig.currentPageAction != null) {
            _addPageData(pageConfig.currentPageAction.widget, pageConfig);
          }
          break;
        default:
          break;
      }
    }
  }

  void replace(PageConfiguration newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(newRoute);
  }

  void setPath(List<MaterialPage> path) {
    _pages.clear();
    _pages.addAll(path);
  }

  void replaceAll(PageConfiguration newRoute) {
    setNewRoutePath(newRoute);
  }

  void push(PageConfiguration newRoute) {
    addPage(newRoute);
  }

  void pushWidget(Widget child, PageConfiguration newRoute) {
    _addPageData(child, newRoute);
  }

  void addAll(List<PageConfiguration> routes) {
    _pages.clear();
    routes.forEach((route) {
      addPage(route);
    });
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            configuration.uiPage;
    if (shouldAddPage) {
      _pages.clear();
      addPage(configuration);
    }
    return SynchronousFuture(null);
  }

  void _setPageAction(PageAction action) {
    switch (action.page.uiPage) {
      case Pages.Splash:
        SplashPageConfig.currentPageAction = action;
        break;
      case Pages.Login:
        LoginPageConfig.currentPageAction = action;
        break;
      case Pages.CreateAccount:
        CreateAccountPageConfig.currentPageAction = action;
        break;
      case Pages.ListItems:
        ListItemsPageConfig.currentPageAction = action;
        break;
      case Pages.Cart:
        CartPageConfig.currentPageAction = action;
        break;
      case Pages.Checkout:
        CheckoutPageConfig.currentPageAction = action;
        break;
      case Pages.Settings:
        SettingsPageConfig.currentPageAction = action;
        break;
      case Pages.WriteSoWon:
        WriteSoWonPageConfig.currentPageAction = action;
        break;
      case Pages.Details:
        DetailsPageConfig.currentPageAction = action;
        break;
      case Pages.AgreePage:
        AgreePageConfig.currentPageAction = action;
        break;
      case Pages.MoreinforNewUser:
        MoreInforNewUserConfig.currentPageAction = action;
        break;
      case Pages.datePicker:
        datePickerConfig.currentPageAction = action;
        break;
      case Pages.WritnickNameChange:
        WritnickNameChangeConfig.currentPageAction = action;
        break;
      case Pages.levelSelector:
        levelSelectorConfig.currentPageAction = action;
        break;
      case Pages.milSelector:
        milSelectorConfig.currentPageAction = action;
        break;
      case Pages.moreInformation:
        moreInformationConfig.currentPageAction = action;
        break;
      case Pages.WritePage:
        WritePageConfig.currentPageAction = action;
        break;

      case Pages.ResetScreen:
        ResetScreenConfig.currentPageAction = action;
        break;
      case Pages.FirstDatePick:
        FirstDatePickConfig.currentPageAction = action;
        break;
      case Pages.FirstLevelSelect:
        FirstLevelSelectConfig.currentPageAction = action;
        break;
      case Pages.FirstMilSelect:
        FirstMilSelectConfig.currentPageAction = action;
        break;
      case Pages.FirstCorpSelect:
        FirstCorpSelectConfig.currentPageAction = action;
        break;

      default:
        break;
    }
  }

  List<Page> buildPages() {
    if (!appState.splashFinished) {
      replaceAll(SplashPageConfig);
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
          _setPageAction(appState.currentAction);
          pushWidget(
              appState.currentAction.widget, appState.currentAction.page);
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
      setNewRoutePath(SplashPageConfig);
      return;
    }

    // Handle navapp://deeplinks/details/#
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == 'details') {
        pushWidget(
            Details(
                int.parse(uri.pathSegments[1]).toString(),
                int.parse(uri.pathSegments[1]).toString(),
                int.parse(uri.pathSegments[1]).toString(),
                int.parse(uri.pathSegments[1]).toString(),
                int.parse(uri.pathSegments[1]).toString(),
                int.parse(uri.pathSegments[1]).toString(),
                int.parse(uri.pathSegments[1]).toString(),
                int.parse(uri.pathSegments[1]).toString(),
                int.parse(uri.pathSegments[1]).toString(),
                int.parse(uri.pathSegments[1]).toString()),

    DetailsPageConfig);
      } else if (uri.pathSegments[0] == 'WritePage') {
        pushWidget(
            WritePages(
              int.parse(uri.pathSegments[1]).toString(),
            ),
            WritePageConfig);
      }
    } else if (uri.pathSegments.length == 1) {
      final path = uri.pathSegments[0];
      switch (path) {
        case 'splash':
          replaceAll(SplashPageConfig);
          break;
        case 'login':
          replaceAll(LoginPageConfig);
          break;
        case 'createAccount':
          setPath([
            _createPage(Login(), LoginPageConfig),
            _createPage(agreePage(), AgreePageConfig),
            _createPage(CreateAccount(), CreateAccountPageConfig)
          ]);
          break;
        case 'listItems':
          replaceAll(ListItemsPageConfig);
          break;
        case 'cart':
          setPath([
            _createPage(ListItems(), ListItemsPageConfig),
            _createPage(Cart(), CartPageConfig)
          ]);
          break;

        case 'checkout':
          setPath([
            _createPage(ListItems(), ListItemsPageConfig),
            _createPage(Checkout(), CheckoutPageConfig)
          ]);
          break;

        case 'WriteSoWon':
          setPath([
            _createPage(ListItems(), ListItemsPageConfig),
            _createPage(writeSoWon(), WriteSoWonPageConfig)
          ]);
          break;
        case 'AgreePage':
          setPath([
            _createPage(Login(), LoginPageConfig),
            _createPage(agreePage(), AgreePageConfig)
          ]);
          break;
        case 'MoreinforNewUser':
          setPath([
            _createPage(ListItems(), ListItemsPageConfig),
            _createPage(moreInforNewUser(), MoreInforNewUserConfig)
          ]);
          break;
        case 'WritnickNameChange':
          setPath([
            _createPage(ListItems(), ListItemsPageConfig),
            _createPage(moreInforNewUser(), MoreInforNewUserConfig),
            _createPage(nickNameChange(), WritnickNameChangeConfig),
          ]);
          break;
        case 'levelSelector':
          setPath([
            _createPage(ListItems(), ListItemsPageConfig),
            _createPage(moreInforNewUser(), MoreInforNewUserConfig),
            _createPage(levelSelector(), levelSelectorConfig),
          ]);
          break;
        case 'milSelector':
          setPath([
            _createPage(ListItems(), ListItemsPageConfig),
            _createPage(moreInforNewUser(), MoreInforNewUserConfig),
            _createPage(milSelector(), milSelectorConfig),
          ]);
          break;
        case 'datePicker':
          setPath([
            _createPage(ListItems(), ListItemsPageConfig),
            _createPage(moreInforNewUser(), MoreInforNewUserConfig),
            _createPage(datePicker(), datePickerConfig),
          ]);
          break;
        case 'moreInformation':
          setPath([
            _createPage(ListItems(), ListItemsPageConfig),
            _createPage(moreInforNewUser(), MoreInforNewUserConfig),
            _createPage(moreInformation(), moreInformationConfig),
          ]);
          break;

        case 'ResetScreen':
          setPath([
            _createPage(Login(), LoginPageConfig),
            _createPage(ResetScreen(), moreInformationConfig),
          ]);
          break;

        case 'FirstDatePick':
          setPath([
            _createPage(CreateAccount(), CreateAccountPageConfig),
            _createPage(FirstDatePick(), FirstDatePickConfig)
          ]);
          break;
        case 'FirstLevelSelect':
          setPath([
            _createPage(FirstDatePick(), FirstDatePickConfig),
            _createPage(FirstLevelSelect(), FirstLevelSelectConfig),
          ]);
          break;
        case 'FirstMilSelect':
          setPath([
            _createPage(FirstLevelSelect(), FirstLevelSelectConfig),
            _createPage(FirstMilSelect(), FirstMilSelectConfig),
          ]);
          break;
        case 'FirstCorpSelect':
          setPath([
            _createPage(FirstMilSelect(), FirstMilSelectConfig),
            _createPage(FirstCorpSelect(), FirstCorpSelectConfig),
          ]);
          break;
      }
    }
  }
}
