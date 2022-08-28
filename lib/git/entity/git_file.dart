class GitFile {
  String? path;
  String? mode;
  String? type;
  String? sha;
  int? size;
  String? url;

  GitFile({this.path, this.mode, this.type, this.sha, this.size, this.url});

  GitFile.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    mode = json['mode'];
    type = json['type'];
    sha = json['sha'];
    size = json['size'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = path;
    data['mode'] = mode;
    data['type'] = type;
    data['sha'] = sha;
    data['size'] = size;
    data['url'] = url;
    return data;
  }
}
