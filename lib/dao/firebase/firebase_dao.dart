part of main_class.dao.firebase;

typedef FromJson<M extends Model> = M Function(
    String id, Map<String, dynamic> json);
typedef ToJson<M extends Model> = Map<String, dynamic> Function(M model);

abstract class FirebaseDAO<M extends Model> implements DAO<M> {
  String collectionName;
  FromJson<M> fromJson;
  ToJson<M> toJson;

  FirebaseDAO({this.collectionName, this.fromJson, this.toJson});

  firestore.CollectionReference get _collection =>
      firestore.FirebaseFirestore.instance.collection(collectionName);

  @override
  Future<M> save(M model) async {
    if (model.id == null) {
      Map<String, dynamic> json = toJson(model);

      firestore.DocumentReference doc = await _collection.add(json);

      return fromJson(doc.id, json);
    } else {
      Map<String, dynamic> json = toJson(model);

      firestore.DocumentReference ref = _collection.doc(model.id);

      await ref.set(json);

      return fromJson(model.id, json);
    }
  }

  @override
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }

  @override
  Future<M> get(String id) async {
    firestore.DocumentSnapshot doc = await _collection.doc(id).get();

    return fromJson(doc.id, doc.data());
  }

  Stream<M> live(String id) {
    return _collection.doc(id).snapshots(includeMetadataChanges: true).map(
          (snap) => snap.exists ? fromJson(snap.id, snap.data()) : null,
        );
  }

  Future<List<M>> list() async {
    firestore.QuerySnapshot query = await _collection.get();

    return query.docs.map((doc) => fromJson(doc.id, doc.data())).toList();
  }
}
