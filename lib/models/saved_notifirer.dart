import 'package:flutter/foundation.dart';

class SavedNotifier extends ChangeNotifier{
  // changenotifier는 우리가 저장한 값이 바뀔때 마다 알려주는 역할을 한다.

  final Set<String> _saved = <String>{};
  //원하는 값을 저장할 것고 이게 변경될 때마다 이 데이터를 사용하는 위젯들에게 알려준다.

void insertSaved(String newSaved){ //단어를 가져와서 여기 넣어준다.
  _saved.add(newSaved);
  notifyListeners(); //이 노티를 사용하는 위젯들에게 알려주는 역할을 수행. 위젯 데이터를 알아서 잘바꿔라ㅣ


}
Set<String> get saved => _saved; //해당 saved데이터를 볼 수 있겠끔 전달한다.

// Set<WordPair> getSaved(){
//   return _saved;
// }


}