import 'package:cloud_firestore/cloud_firestore.dart';

class Rate {
  final int value;
  final int votes;
  final DocumentReference documentReference;

  Rate.fromMapData(Map<String, Object> data, this.documentReference)
      : assert(data['votes'] != null),
        assert(documentReference != null),
        votes = data['votes'],
        value = int.parse(documentReference.documentID);

  Rate.fromDocumentSnapshot(DocumentSnapshot documentSnapshot)
      : this.fromMapData(documentSnapshot.data, documentSnapshot.reference);

  @override
  String toString() => "Record<$value:$votes>";
}
