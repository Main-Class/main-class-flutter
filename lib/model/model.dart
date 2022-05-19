part of main_class.model;

abstract class Model<T> {
  T? id;

  Model({this.id});

  @override
  bool operator ==(other) {
    return other is Model && id == other.id;
  }
}
