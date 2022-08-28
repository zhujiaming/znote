class Blob {
  String? sha;
  int? size;
  String? url;
  String? content;
  String? encoding;

  Blob({this.sha, this.size, this.url, this.content, this.encoding});

  Blob.fromJson(Map<String, dynamic> json) {
    sha = json['sha'];
    size = json['size'];
    url = json['url'];
    content = json['content'];
    encoding = json['encoding'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sha'] = this.sha;
    data['size'] = this.size;
    data['url'] = this.url;
    data['content'] = this.content;
    data['encoding'] = this.encoding;
    return data;
  }
}