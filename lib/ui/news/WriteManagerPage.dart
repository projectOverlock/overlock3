import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:overlock/Repository/firestorage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';


String colName = "newsList";

// 필드명
final String fnName = "name";
final String fnDescription = "description";
final String fnDatetime = "datetime";
final String recomand = "Recomand";
final String fnCatagory = "Catagory";
final String userID = "userID";
final String pageView = "pageView";
final String likes = "likes";
final String replys = "replys";
String _selectedValue = '폭언';
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
String id = '';
String nickname = 'default';
SharedPreferences prefs;
final _valueList = ['폭언', '폭행', '성추행', '성폭행', '소원수리', '불평등', '부조리', '비리'];
final FirebaseAuth _auth = FirebaseAuth.instance;
Firestorage_repository _firestorageRepository = Firestorage_repository();
String downloadUrl ='noImage';


class WriteMangerPage extends StatefulWidget {


  @override
  _WriteMangerPageState createState() => _WriteMangerPageState();
}
enum AppStates {
  free,
  picked,
  cropped,
}

class _WriteMangerPageState extends State<WriteMangerPage> {
  AppStates state;
  File imageFile;

  @override
  void initState() {
    super.initState();
    state = AppStates.free;
  }

  @override
  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _newDescCon = TextEditingController();


  Widget build(BuildContext context) {

    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser.uid.toString())
        .get()
        .then((doc) {
      nickname = doc["name"];
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: const Text(
          '뉴스게시판 작성',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_library_add),
            onPressed: () {
              if (_newDescCon.text.isNotEmpty && _newNameCon.text.isNotEmpty) {
                if(state == AppStates.cropped)
                createDoc(_newNameCon.text, _newDescCon.text, _selectedValue,
                    nickname, downloadUrl);
                else
                  {
                    createDoc(_newNameCon.text, _newDescCon.text, _selectedValue,
                        nickname, "noImage");
                  }
              }
              _newNameCon.clear();
              _newDescCon.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            DropdownButton(
              isExpanded: true,
              value: _selectedValue,
              items: _valueList.map((value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),



            SizedBox(
              height: 50,
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: "제목을 작성하세요"),
                controller: _newNameCon,
              ),
            ),
            Flexible(
              child: TextField(
                maxLines: null,
                minLines: null,
                expands: true,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6
                    .copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    height: 1.5),
                decoration: InputDecoration(

                  alignLabelWithHint: true,
                  labelText: "내용을 작성하세요",
                  hintStyle: TextStyle(
                      fontSize: 14,
                      letterSpacing: 0.2,
                      height: 1.2),
                ),
                controller: _newDescCon,
              ),
            ),

            Container(
              alignment: Alignment.centerLeft,
              child:
              TextButton.icon(
                  onPressed: () {
                    if (state == AppStates.free)
                      _pickImage();
                    else if (state == AppStates.picked)
                      _cropImage();
                    else if (state == AppStates.cropped) _clearImage();
                  },

                  icon: Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.grey,
                  ),
                  label: Text(
                    "",
                    style: TextStyle(
                        fontSize: 1,
                        color: Colors.grey),
                  )
              ),
            ),
            Container(
              child: imageFile != null ? SizedBox(height: 50, child: Image.file(imageFile)) : Container(),
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: <Widget>[
                  TextButton(
                    child: Text("취소", style: TextStyle(color: Colors.black),),
                    onPressed: () {
                      _newNameCon.clear();
                      _newDescCon.clear();
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      child: Text("문서작성"),
                      onPressed: () {
                        // if (_newDescCon.text.isNotEmpty &&
                        //     _newNameCon.text.isNotEmpty) {
                        //   createDoc(_newNameCon.text, _newDescCon.text,
                        //       _selectedValue, nickname, downloadUrl);

                          if (_newDescCon.text.isNotEmpty && _newNameCon.text.isNotEmpty){ {
                            if(state == AppStates.cropped)
                              createDoc(_newNameCon.text, _newDescCon.text, _selectedValue,
                                  nickname, downloadUrl);
                            else
                            {
                              createDoc(_newNameCon.text, _newDescCon.text, _selectedValue,
                                  nickname, "noImage");
                            }
                          }
                          _newNameCon.clear();
                          _newDescCon.clear();
                          Navigator.pop(context);
                        }
                        else {
                          if (!_newDescCon.text.isNotEmpty)
                            _newDescCon.text = '내용을 입력해주세요';
                          else if (!_newNameCon.text.isNotEmpty)
                            _newNameCon.text = '제목을 입력해주세요';
                        }
                      },
                    ),
                  )
                ],
              ),
            )

          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.deepOrange,
      //   onPressed: () {
      //     if (state == AppStates.free)
      //       _pickImage();
      //     else if (state == AppStates.picked)
      //       _cropImage();
      //     else if (state == AppStates.cropped) _clearImage();
      //   },
      //   child: _buildButtonIcon(),
      // ),

    );
  }

  Widget _buildButtonIcon() {
    if (state == AppStates.free)
      return Icon(Icons.add);
    else if (state == AppStates.picked)
      return Icon(Icons.crop);
    else if (state == AppStates.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  Future<Null> _pickImage() async {
    final pickedImage =
    await ImagePicker().getImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      _cropImage();
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
        ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
        ]
        : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: kPrimaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppStates.cropped;
      });
      UploadTask task = _firestorageRepository.uploodImageFile(colName, _auth.currentUser.uid, timestampToStrDateTime(Timestamp.now()), imageFile);
      task.snapshotEvents.listen((event) async {
        if (event.bytesTransferred == event.totalBytes) {
          downloadUrl = await event.ref.getDownloadURL();

        }
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppStates.free;
    });
   // downloadUrl ='noImage';
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    nickname = prefs.getString('nickname') ?? '';

    // Force refresh input
    setState(() {});
  }

  void createDoc(String name, String description, var selectedValue, String nk,
      String downloadUrl) {




    FirebaseFirestore.instance.collection(colName).add({

      fnName: name,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
      fnCatagory: selectedValue,

      'nickName': nk,
      pageView: 0,
      likes: 0,
      'hates': 0,
      replys: 0,
      'uid': _auth.currentUser.uid,
      'imageurl':  downloadUrl

    }).then((value) =>
        FirebaseFirestore.instance.collection('all').add({ //전체보기 위한 구문
          'colName': colName,
          fnName: name,
          fnCatagory: selectedValue,

          fnDescription: description,
          fnDatetime: Timestamp.now(),
          'nickName': nk,
          pageView: 0,
          likes: 0,
          'hates': 0,
          replys: 0,
          'uid': _auth.currentUser.uid,
          'value': value.toString()
        })
    );

  }

  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }

  }



