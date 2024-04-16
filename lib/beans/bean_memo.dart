
import 'package:intl/intl.dart';


class Memo {
  int id = 0;
  String url;
  int artistId;
  int adminId;
  String memo;

  Memo({
    this.id = 0,
    this.memo = "",
    this.url = "",
    this.artistId = 0,
    this.adminId = 0,
  });

  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'] as int,
      url: json['url'] as String,
      memo: json['memo'] as String,
      artistId: json['artistId'] as int,
      adminId: json['adminId'] as int,
    );
  }

}
