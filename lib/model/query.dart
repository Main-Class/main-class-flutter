part of main_class.model;

abstract class Query {
  dynamic pageRef;
  int? limit;

  Query({this.limit, this.pageRef});

  Query copyWith({dynamic pageRef, int? limit});
}
