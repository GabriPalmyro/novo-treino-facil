class Follower {
  String? id;
  String? followerId;
  String? name;
  String? photoURL;
  String? email;

  Follower({
    this.id,
    this.followerId,
    this.name,
    this.photoURL,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'followerId': followerId,
      'name': name,
      'photoURL': photoURL,
      'email': email,
    };
  }

  factory Follower.fromMap(Map<String, dynamic> map) {
    return Follower(
      id: map['id'] as String? ?? '',
      followerId: map['followerId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      photoURL: map['photoURL'] as String? ?? '',
      email: map['email'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'Follower(id: $id, followerId: $followerId, name: $name, photoURL: $photoURL, email: $email)';
  }
}
