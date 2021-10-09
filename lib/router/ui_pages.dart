import 'package:flutter/cupertino.dart';

import '../app_state.dart';

const String SplashPath = '/splash';
const String LoginPath = '/login';
const String CreateAccountPath = '/createAccount';
const String ListItemsPath = '/list_items';
const String DetailsPath = '/details';
const String newsDetailsPath = 'news/newsDetails';

const String CartPath = '/cart';
const String WritePage = '/WritePage';
const String CheckoutPath = '/checkout';
const String SettingsPath = '/settings';
const String WriteSoWonPath = 'sowon/WriteSoWon';
const String WritePollRequestPath = 'Poll/writePollRequest';
const String AgreePagePath = 'userInfo/AgreePage';
const String MoreInforNewUserPath = '/moreInforNewUser';
const String datePickerPath = 'userInfo/datePicker';
const String WritnickNameChangePath = 'userInfo/nickNameChange';
const String levelSelectorPath = 'userInfo/LevelSelector';
const String milSelectorPath = 'userInfo/MilSelector';
const String moreInformationPath = 'userInfo/moreInformation';

const String ResetScreenPath = '/ResetScreen';
const String FirstDatePickPath = 'userInfo/FirstDatePick';
const String FirstLevelSelectPath = 'userInfo/FirstLevelSelect';
const String FirstMilSelectPath = 'userInfo/FirstMilSelect';
const String FirstCorpSelectPath = 'userInfo/FirstCorpSelect';
const String ManageListPath = 'ManagePage/ManageList';

const String HomePath = 'AdsTest/AdsTester';
const String RewardedAdsPagePath = 'AdsTest/RewardedAdsPage';
const String reWritePagePath = 'reWritePage';
const String soWonreWritePagePath = 'sowon/soWonreWritePage';



enum Pages {
  Splash,
  Login,
  CreateAccount,
  ListItems,
  Details,
  Cart,
  Checkout,
  Settings,
  WriteSoWon,
  WritePollRequest,
  AgreePage,
  MoreinforNewUser,
  WritnickNameChange,
  levelSelector,
  milSelector,
  moreInformation,
  datePicker,
  WritePage,
  ResetScreen,
  FirstDatePick,
  FirstLevelSelect,
  FirstMilSelect,
  FirstCorpSelect,
  ManageList,
  Home,
  RewardedAdsPage,
  reWritePage,
  soWonreWritePage,
  newsDetails

}

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;
  PageAction currentPageAction;

  PageConfiguration(
      {@required this.key,
      @required this.path,
      @required this.uiPage,
      this.currentPageAction});
}

PageConfiguration WritePageConfig = PageConfiguration(
    key: 'WritePage',
    path: SplashPath,
    uiPage: Pages.WritePage,
    currentPageAction: null);
PageConfiguration SplashPageConfig = PageConfiguration(
    key: 'Splash',
    path: SplashPath,
    uiPage: Pages.Splash,
    currentPageAction: null);
PageConfiguration LoginPageConfig = PageConfiguration(
    key: 'Login',
    path: LoginPath,
    uiPage: Pages.Login,
    currentPageAction: null);
PageConfiguration CreateAccountPageConfig = PageConfiguration(
    key: 'CreateAccount',
    path: CreateAccountPath,
    uiPage: Pages.CreateAccount,
    currentPageAction: null);
PageConfiguration ListItemsPageConfig = PageConfiguration(
    key: 'ListItems',
    path: ListItemsPath,
    uiPage: Pages.ListItems,
    currentPageAction: null);

PageConfiguration DetailsPageConfig = PageConfiguration(
    key: 'Details',
    path: DetailsPath,
    uiPage: Pages.Details,
    currentPageAction: null);

PageConfiguration newsDetailsPageConfig = PageConfiguration(
    key: 'newsDetails',
    path: newsDetailsPath,
    uiPage: Pages.newsDetails,
    currentPageAction: null);

PageConfiguration CartPageConfig = PageConfiguration(
    key: 'Cart', path: CartPath, uiPage: Pages.Cart, currentPageAction: null);
PageConfiguration CheckoutPageConfig = PageConfiguration(
    key: 'Checkout',
    path: CheckoutPath,
    uiPage: Pages.Checkout,
    currentPageAction: null);
PageConfiguration WriteSoWonPageConfig = PageConfiguration(
    key: 'WriteSoWon',
    path: WriteSoWonPath,
    uiPage: Pages.WriteSoWon,
    currentPageAction: null);
PageConfiguration writePollRequestPageConfig = PageConfiguration(
    key: 'WritePollRequest',
    path: WritePollRequestPath,
    uiPage: Pages.WritePollRequest,
    currentPageAction: null);
PageConfiguration AgreePageConfig = PageConfiguration(
    key: 'AgreePage',
    path: AgreePagePath,
    uiPage: Pages.AgreePage,
    currentPageAction: null);
PageConfiguration HomeConfig = PageConfiguration(
    key: 'Home',
    path: HomePath,
    uiPage: Pages.Home,
    currentPageAction: null);
PageConfiguration RewardedAdsPageConfig = PageConfiguration(
    key: 'RewardedAdsPage',
    path: RewardedAdsPagePath,
    uiPage: Pages.RewardedAdsPage,
    currentPageAction: null);

PageConfiguration MoreInforNewUserConfig = PageConfiguration(
    key: 'MoreInforNewUser',
    path: MoreInforNewUserPath,
    uiPage: Pages.MoreinforNewUser,
    currentPageAction: null);

PageConfiguration datePickerConfig = PageConfiguration(
    key: 'datePicker',
    path: datePickerPath,
    uiPage: Pages.datePicker,
    currentPageAction: null);

PageConfiguration SettingsPageConfig = PageConfiguration(
    key: 'Settings',
    path: SettingsPath,
    uiPage: Pages.Settings,
    currentPageAction: null);

PageConfiguration WritnickNameChangeConfig = PageConfiguration(
    key: 'WritnickNameChange',
    path: WritnickNameChangePath,
    uiPage: Pages.WritnickNameChange,
    currentPageAction: null);
PageConfiguration levelSelectorConfig = PageConfiguration(
    key: 'levelSelector',
    path: levelSelectorPath,
    uiPage: Pages.levelSelector,
    currentPageAction: null);
PageConfiguration milSelectorConfig = PageConfiguration(
    key: 'milSelector',
    path: milSelectorPath,
    uiPage: Pages.milSelector,
    currentPageAction: null);
PageConfiguration moreInformationConfig = PageConfiguration(
    key: 'moreInformation',
    path: moreInformationPath,
    uiPage: Pages.moreInformation,
    currentPageAction: null);

PageConfiguration ResetScreenConfig = PageConfiguration(
    key: 'ResetScreen',
    path: ResetScreenPath,
    uiPage: Pages.ResetScreen,
    currentPageAction: null);
PageConfiguration FirstDatePickConfig = PageConfiguration(
    key: 'FirstDatePick',
    path: FirstDatePickPath,
    uiPage: Pages.FirstDatePick,
    currentPageAction: null);
PageConfiguration FirstLevelSelectConfig = PageConfiguration(
    key: 'FirstLevelSelect',
    path: FirstLevelSelectPath,
    uiPage: Pages.FirstLevelSelect,
    currentPageAction: null);
PageConfiguration FirstMilSelectConfig = PageConfiguration(
    key: 'FirstMilSelect',
    path: FirstMilSelectPath,
    uiPage: Pages.FirstMilSelect,
    currentPageAction: null);
PageConfiguration FirstCorpSelectConfig = PageConfiguration(
    key: 'FirstCorpSelect',
    path: FirstCorpSelectPath,
    uiPage: Pages.FirstCorpSelect,
    currentPageAction: null);

PageConfiguration ManageListConfig = PageConfiguration(
    key: 'ManageList',
    path: ManageListPath,
    uiPage: Pages.ManageList,
    currentPageAction: null);

PageConfiguration reWritePageConfig = PageConfiguration(
key: 'reWritePage',
path: reWritePagePath,
uiPage: Pages.reWritePage,
currentPageAction: null);


PageConfiguration soWonreWritePageConfig = PageConfiguration(
    key: 'soWonreWritePage',
    path: soWonreWritePagePath,
    uiPage: Pages.soWonreWritePage,
    currentPageAction: null);