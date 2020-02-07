import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/rate.dart';

class Vote extends StatefulWidget {
  final VoidCallback voteCallback;

  Vote(this.voteCallback) : assert(voteCallback != null);

  @override
  State<Vote> createState() => VoteState(voteCallback);
}

class VoteState extends State<Vote> {
  final VoidCallback voteCallback;

  VoteState(this.voteCallback) : assert(voteCallback != null);

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('rate').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data.documents,
              voteCallback: voteCallback);
        });
  }
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> documents,
    {VoidCallback voteCallback}) {
  return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
          children: documents
              .map((document) =>
                  _buildListItem(context, document, voteCallback: voteCallback))
              .toList()));
}

Widget _buildListItem(BuildContext context, DocumentSnapshot documentSnapshot,
    {VoidCallback voteCallback}) {
  final rate = Rate.fromDocumentSnapshot(documentSnapshot);

  return Padding(
      key: ValueKey(rate.value),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0)),
          child: ListTile(
            title: _buildRateTitle(context, rate.value),
            onTap: () => Firestore.instance.runTransaction((transaction) async {
              voteCallback();
              final freshSnapshot =
                  await transaction.get(rate.documentReference);
              final fresh = Rate.fromDocumentSnapshot(freshSnapshot);
              await transaction
                  .update(rate.documentReference, {'votes': fresh.votes + 1});
            }),
          )));
}

Row _buildRateTitle(BuildContext context, int rate) {
  final stars = <Widget>[];
  for (int i = 0; i < rate; i++) {
    stars.add(Icon(Icons.star, color: Theme.of(context).primaryColor));
  }
  for (int i = rate; i < 5; i++) {
    stars.add(Icon(Icons.star_border, color: Theme.of(context).primaryColor));
  }
  return Row(
    children: stars,
  );
}
