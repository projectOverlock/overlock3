import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:overlock/ui/cart.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../router/ui_pages.dart';

class Details extends StatefulWidget {
  final String id;
  final String colname;

  const Details(this.id, String this.colname);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final size = query.size;

    _scaffoldKey.currentState;
    CollectionReference firstDemo =
        FirebaseFirestore.instance.collection(widget.colname);

    final appState = Provider.of<AppState>(context, listen: false);

    return FutureBuilder<DocumentSnapshot>(
      future: firstDemo.doc(widget.id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();

          return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.red[900],
              ),
              body: ListView(children: <Widget>[
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${data['name']}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(color: Colors.black, fontSize: 20)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${data['userID']}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.red, fontSize: 16)),
                        ),

                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: size.height*0.6,
                            child: Text("${data['description']}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(color: Colors.black, fontSize: 18, letterSpacing: 0.2, height: 1.5),),
                          ),
                        ),
                        Divider(),
                        Container(

                              child: Row(
                                children: <Widget>[
                                  FlatButton.icon(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.view_agenda,
                                        size: 12,
                                        color: Colors.grey,
                                      ),
                                      label: Text("1000")),
                                  FlatButton.icon(
                                      onPressed: () {},
                                      icon: Icon(
                                          Icons.favorite_border,
                                          size: 12,
                                          color: Colors.grey),
                                      label: Text("500")),
                                  FlatButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.add_comment,
                                          size: 12,
                                          color: Colors.grey),
                                      label: Text("20")),
                                ],
                              ),
                            )
                          ],
                        ),
                  ),
                  ),

              ]));
        }

        return Scaffold();
      },
    );
  }
}
