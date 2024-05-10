
class DataMemo {
  int id = 0;
  String url;
  int artistId;
  int adminId;
  String memo;

  DataMemo({
    this.id = 0,
    this.memo = "",
    this.url = "",
    this.artistId = 0,
    this.adminId = 0,
  });

  factory DataMemo.fromJson(Map<String, dynamic> json) {
    return DataMemo(
      id: json['id'] as int,
      url: json['url'] as String,
      memo: json['memo'] as String,
      artistId: json['artistId'] ?? 0,
      adminId: json['adminId'] ?? 0,
    );
  }

}
