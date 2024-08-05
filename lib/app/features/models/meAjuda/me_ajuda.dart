class MeAjuda {
  String? id;
  String? title;
  String? description;
  String? link;
  bool? show;

  MeAjuda({this.id, this.title, this.description, this.link, this.show});

  @override
  String toString() =>
      'MeAjuda(id: $id, title: $title, description: $description, link: $link)';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': title,
      'descricao': description,
      'link': link,
      'mostrar': show
    };
  }

  factory MeAjuda.fromMap(Map<String, dynamic> map) {
    return MeAjuda(
      id: map['id'] as String ?? '',
      title: map['titulo'] as String ?? '',
      description: map['descricao'] as String ?? '',
      link: map['link'] as String ?? '',
      show: map['mostrar'] as bool ?? false,
    );
  }
}
