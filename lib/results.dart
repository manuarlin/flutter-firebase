import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/rate.dart';

class Results extends StatefulWidget {
  @override
  State<Results> createState() => ResultsState();
}

class ResultsState extends State<Results> {
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('rate').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data.documents);
        });
  }
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> documents) {
  final rates =
      documents.map((document) => Rate.fromDocumentSnapshot(document));
  final totalVotes = rates.fold(0, (val, element) => val + element.votes);
  return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
          children: rates
              .map((rate) => _buildListItem(context, rate, totalVotes))
              .toList()));
}

Widget _buildListItem(BuildContext context, Rate rate, int totalVotes) {
  return Padding(
      key: ValueKey(rate.value),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)),
        child: ListTile(
            title: Row(
              children: <Widget>[
                Text(rate.value.toString()),
                Icon(Icons.star, color: Theme.of(context).primaryColor)
              ],
            ),
            trailing: SizedBox(
                width: 180,
                child: LinearProgressIndicator(
                  value: rate.votes / totalVotes,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ))),
      ));
}
