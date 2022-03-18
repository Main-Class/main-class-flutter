part of main_class.dao.firebase;

abstract class FirebaseQueryDAO<M extends Model, Q extends Query>
    extends QueryDAO<M, Q> {
  final String collectionName;
  final bool group;
  final FromJson<M> fromJson;

  FirebaseQueryDAO({this.collectionName, this.group = false, this.fromJson});

  firestore.Query get _collection => group
      ? firestore.FirebaseFirestore.instance.collectionGroup(collectionName)
      : firestore.FirebaseFirestore.instance.collection(collectionName);

  @override
  Future<Page<M>> query(Q query) async {
    firestore.Query whereQuery = where(_collection, query);

    if (query.pageRef != null) {
      whereQuery = whereQuery.startAfterDocument(query.pageRef);
    }

    firestore.QuerySnapshot snapshot =
        await whereQuery.limit(query.limit ?? 10).get();

    return Page(
      result: snapshot.docs.map((doc) => fromJson(doc.id, doc.data())).toList(),
      nextPageRef: snapshot.docs.length == (query.limit ?? 10)
          ? snapshot.docs.last
          : null,
    );
  }

  firestore.Query where(firestore.Query firestoreQuery, Q query);
}
