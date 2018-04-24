class SuperHero {
  String id;
  String name;
  String image;
  String desc;

  SuperHero.fromJson(Map json) {
    final tempName = json['aliases'];
    name = tempName == null ? "Unknown" : tempName.toString().split("\n").first;

    final images = json['image'];
    if (images != null) {
      image = images['small_url'];
    }
    desc = json['deck'] == null ? "Unknown" : json['deck'];
    id = json['id'].toString();
  }
}
