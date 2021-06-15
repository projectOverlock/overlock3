import 'package:flutter/cupertino.dart';

class SavedNotifier extends ChangeNotifier{

  final Set<int> _saved = <int>{};

  void insertSaved(int newSaved){
    _saved.add(newSaved);
    notifyListeners();
  }
  Set<int> get saved => _saved;
}