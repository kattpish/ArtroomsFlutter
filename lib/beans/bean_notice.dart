
import 'package:intl/intl.dart';

class MyNotice {

  int id;
  String notice;
  String url;
  int artistId;
  bool noticeable;
  String createdAt;

  MyNotice({
    this.id = 0,
    this.notice = "",
    this.url = "",
    this.artistId = 0,
    this.noticeable = false,
    this.createdAt = "",
  });

  factory MyNotice.fromJson(Map<String, dynamic> json) {
    return MyNotice(
      id: json['id'] as int,
      notice: json['notice'] as String,
      url: json['url'] as String,
      artistId: json['artistId'] as int,
      noticeable: json['noticeable'] as bool,
      createdAt: json['createdAt'] as String,
    );
  }

  String getDate() {
    if(createdAt.isNotEmpty) {
      DateTime dateTime = DateTime.parse(createdAt);
      return DateFormat('yyyy.M.d').format(dateTime);
    }else {
      return "";
    }
  }

}
