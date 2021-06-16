import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'router/ui_pages.dart';

const String LoggedInKey = 'LoggedIn';


enum PageState { none, addPage, addAll, addWidget, pop, replace, replaceAll }

class PageAction {
  PageState state;
  PageConfiguration page;
  List<PageConfiguration> pages;
  Widget widget;

  PageAction(
      {this.state = PageState.none,
      this.page = null,
      this.pages = null,
      this.widget = null});
}

class AppState extends ChangeNotifier {
  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;
  bool _splashFinished = false;

  bool get splashFinished => _splashFinished;
  final cartItems = [];
  String emailAddress;
  String password;
  PageAction _currentAction = PageAction();

  PageAction get currentAction => _currentAction;

  set currentAction(PageAction action) {
    _currentAction = action;
    notifyListeners();
  }

  AppState() {
    getLoggedInState();
  }

  void resetCurrentAction() {
    _currentAction = PageAction();
  }

  void addToCart(String item) {
    cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(String item) {
    cartItems.add(item);
    notifyListeners();
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }

  void setSplashFinished() {
    _splashFinished = true; //스플래쉬 종료로 설정.
    if (_loggedIn) { //로긴 상태면
      _currentAction =
          PageAction(state: PageState.replaceAll, page: ListItemsPageConfig); //페이지 상태를 replaceall하고 리스트아이템 페이지로 설정한다.
    } else {
      _currentAction =
          PageAction(state: PageState.replaceAll, page: LoginPageConfig); //로긴 상태가 아니면 로그인 페이지로 설정한다.
    }
    notifyListeners();
  }

  void login() {
    _loggedIn = true; //로그인 수행시 로그인 상태를 true로 설정한다.
    saveLoginState(loggedIn);
    _currentAction =
        PageAction(state: PageState.replaceAll, page: ListItemsPageConfig); //메인페이지로 이동시킨다.
    notifyListeners(); //노티파이 리스너 실행
  }

  void logout() {
    _loggedIn = false;
    saveLoginState(loggedIn);
    _currentAction =
        PageAction(state: PageState.replaceAll, page: LoginPageConfig); //로그인 페이지로 이동.
    notifyListeners();
  }

  void saveLoginState(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance(); //로그인상태를 저장할 preference 인스턴스 생성
    prefs.setBool(LoggedInKey, loggedIn); //로그인상태 셋.
  }


// preference에 로그인 상태를 저장.
  void getLoggedInState() async {
    final prefs = await SharedPreferences.getInstance(); //preference 인스턴스 생성
    _loggedIn = prefs.getBool(LoggedInKey); // 로그인 상태 저장. 로그인 키로 로그인 Bool 값 불러오기
    if (_loggedIn == null) { //만약 로그인 상태가 null일 경우
      _loggedIn = false; //로그인 값을 false로 설정 (로그아웃 상태로 설정)
    }
  }
}
