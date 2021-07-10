import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:overlock/ui/Poll/pollResult.dart';

import '../../constants.dart';


class pollPages extends StatefulWidget {

  pollPages(this.pollName, this.Contents);
  final String pollName;
  final String Contents;


  @override
  _pollPagesState createState() => _pollPagesState();
}

class _pollPagesState extends State<pollPages> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pollName), backgroundColor: kPrimaryColor,),
      body: _buildBody(context),
      );
  }

  Widget _buildBody(BuildContext context)
  {
    return StreamBuilder<QuerySnapshot>( // 데이터 읽어드리기, firebase에 데이터들이 있는데 이게 변할때 정보를 계속 읽어주는 역할 수행.
      stream: FirebaseFirestore.instance.collection(widget.pollName).snapshots(), //snapshot에 데이터 저장.(name, votes)
      builder: (context, snapshot) { //builder에 스냅샷 전달
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }

        return _buildList(context, snapshot.data.docs); //스냅샷의 docs 값들 전달.
      }
    );
  }
  Widget _buildList(BuildContext context, List<DocumentSnapshot> docs){
    return  ListView( //리스트뷰 생성
          padding: const EdgeInsets.only(top: 20.0),
          children: docs.map((doc)=> _buildListItem(context, doc)).toList() // doc 안에 데이터들을 돌아가면서 수행.
        );

  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot doc)
  {
    final record = Record.fromSnapshot(doc); //전달받은 doc를 recorde 클래스에 넣어 입력

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile( // 화면에 도시
          title: Text(record.name),
          trailing: Text(record.votes.toString()),
          onTap: () => FirebaseFirestore.instance.runTransaction((transaction) async { // 탭입력시 서버에 쓰고 카운트 증가
            final freshDoc = await transaction.get(record.reference);
            final freshRecord = Record.fromSnapshot(freshDoc);
            await transaction.update(record.reference, {'votes': freshRecord.votes + 1});
            Navigator.push( context, MaterialPageRoute( builder: (context) => pollResult(), ));
          }),
        ),
      ),
    );
  }

}
class Record {
  final String name;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference}) // 맵으로 부터 값을 받아 입력
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        name = map['name'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot doc) : this.fromMap(doc.data(), reference: doc.reference);

  @override
  String toString() => "Record<$name:$votes>";
}