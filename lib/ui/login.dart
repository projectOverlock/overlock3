import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_state.dart';
import '../constants.dart';
import '../router/ui_pages.dart';
import '../size_config.dart';
import 'splash_content.dart';

bool isLoggedIn = false;
bool isLoading = false;
User currentUser;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
  final String currentUserId = '';
}

int currentPage = 0;
List<Map<String, String>> splashData = [
  {
    "text": "오버로크에 오신걸 환영합니다.\n 오버로크는 군인을 위한 익명 소통 서비스입니다.",
    "image": "assets/images/splash_1.png"
  },
  {
    "text": "온라인 소원수리에 참여하세요. \n 군 내부 문제를 함께 고민하고, 세상에 알리겠습니다.",
    "image": "assets/images/splash_2.png"
  },
  {
    "text": "온라인 동기를 사귀세요. \n 온라인에는 여러분의 5000명의 동기가 있습니다.",
    "image": "assets/images/splash_3.png"
  },
];

class _LoginState extends State<Login> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences prefs;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  OutlineInputBorder _border = OutlineInputBorder();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final query = MediaQuery.of(context);
    final size = query.size;
    final itemWidth = size.width;
    final itemHeight = itemWidth * (size.width / size.height);
    _passwordController.text = appState.password;
    _emailController.text = appState.emailAddress;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 25,
                  child: PageView.builder(  //어플리케이션 소개 페이지 생성(상단)
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    itemCount: splashData.length,
                    itemBuilder: (context, index) => SplashContent(
                      image: splashData[index]["image"],
                      text: splashData[index]['text'],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate( // 색인 표시
                            splashData.length,
                            (index) => buildDot(index: index),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 18.0, right: 18.0, bottom: 10),
                  child: buildTextFormField( // 이메일 주소(아이디 입력)
                      "Email Address", _emailController, false),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18.0, right: 18.0, bottom: 10),
                  child:
                      buildTextFormField("Password", _passwordController, true),// 비번 입력
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          side: const BorderSide(color: Colors.black),
                        ),
                        onPressed: () {
                          appState.currentAction = PageAction(
                              state: PageState.addPage,
                              page: CreateAccountPageConfig);
                        },
                        child: const Text(
                          '계정 생성',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          side: BorderSide(
                            color: Colors.red[900],
                          ),
                        ),
                        // onPressed: () {
                        //   appState.login();
                        // },
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            await _signInWithEmailAndPassword();
                          }
                          appState.login();
                        },
                        child: const Text(
                          '로그인',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
                Spacer(
                  flex: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  TextFormField buildTextFormField(
      String labelText, TextEditingController controller, bool isPassword) {
    return TextFormField(
        cursorColor: Colors.red[900],
        obscureText: isPassword ? true : false,
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: labelText,
          filled: false,
          fillColor: Colors.black45,
          border: _border,
          errorBorder: _border.copyWith(
              borderSide: BorderSide(color: Colors.red[900], width: 2)),
          enabledBorder: _border.copyWith(
              borderSide: BorderSide(color: Colors.grey, width: 1)),
          focusedBorder: _border.copyWith(
              borderSide: BorderSide(color: Colors.red[900], width: 1)),
          errorStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(color: Colors.black),
        ));
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      final appState = Provider.of<AppState>(context, listen: false);
      appState.login();

      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .get();

      FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser.uid)
          .get()
          .then((value) => user.updateProfile(displayName: value['name']));

      await prefs.setString('id', currentUser.uid);
      await prefs.setString('name', currentUser.displayName);
      await prefs.setString('photoUrl', currentUser.photoURL);
      //
      // final List<DocumentSnapshot> documents = result.docs;
      // // if (documents.length == 0) {
      // //   // Update data to server if new user
      // //   FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      // //     'name': user.displayName,
      // //     'photoUrl': user.photoURL,
      // //     'id': user.uid,
      // //     'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      // //     'chattingWith': null
      // //   });
      //
      //   // Write data to local
      //   currentUser = user;
      //
      // } else {
      //   // Write data to local
      //   await prefs.setString('id', documents[0]['id']);
      //   await prefs.setString('nickname', documents[0]['nickname']);
      //   await prefs.setString('photoUrl', documents[0]['photoUrl']);
      //   await prefs.setString('aboutMe', documents[0]['aboutMe']);
      // }
      //
      // print("로그인성공");

      // Provider.of<PageNotifier>(context, listen: false).goToOtherPage(OverlockMain.pageName);

    } catch (e) {
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Email & Password'),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
