class RoocketProduct {
  int id;
  int userId;
  String title;
  String body;
  String image;
  String price;
  DateTime createdAt;
  DateTime updatedAt;

  RoocketProduct.fromJson(Map<String, dynamic> parsedJson){
    id = parsedJson['id'];
    userId = parsedJson['userId'];
    title = parsedJson['title'];
    body = parsedJson['body'];
    image = parsedJson['image'];
    price = parsedJson['price'];
    createdAt = parsedJson['createdAt'];
    updatedAt = parsedJson['updatedAt'];
  }

  @override
  String toString() {
    return "{id: $id}";
  }
}