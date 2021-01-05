part of main_class.dao.firebase;

abstract class FirebaseLiveQueryDAO<M extends Model, Q extends Query> {
  final String collectionName;
  final FromJson<M> fromJson;

  FirebaseLiveQueryDAO({this.collectionName, this.fromJson});

  firestore.CollectionReference get _collection =>
      firestore.Firestore.instance.collection(collectionName);

  @override
  Stream<List<M>> query(Q query) {
    firestore.Query whereQuery = where(_collection, query);

    if (query.pageRef != null) {
      whereQuery = whereQuery.startAfterDocument(query.pageRef);
    }

    if (query.limit != null) {
      whereQuery = whereQuery.limit(query.limit);
    }

    Stream<firestore.QuerySnapshot> stream = whereQuery.snapshots();

    return stream.map(
      (snap) => snap.docs.map((doc) => fromJson(doc.id, doc.data())).toList(),
    );
  }

  firestore.Query where(firestore.CollectionReference collection, Q query);
}
