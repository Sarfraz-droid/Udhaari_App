// ignore: file_names
class ProfileModel {
  final String? name;
  final String? email;
  final String? photo;
  final String? uid;
  final List<String>? caseSearch;

  ProfileModel({
    this.name,
    this.email,
    this.photo,
    this.uid,
    this.caseSearch,
  });

  fromJSON(Map<String, dynamic> json) {
    // print(json);
    ProfileModel _profile = ProfileModel(
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      uid: json['uid'],
    );

    return _profile;
  }

  factory ProfileModel.fromJSON(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      uid: json['uid'],
    );
  }

  toJSON() {
    return {
      "name": name,
      "email": email,
      "photo": photo,
      "uid": uid,
    };
  }
}
