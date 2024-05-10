
import 'package:intl/intl.dart';


class DataNotice {

  int id = 0;
  String title;
  String notice;
  String url;
  int artistId;
  bool noticeable;
  String createdAt;

  DataNotice({
    this.id = 0,
    this.title = "",
    this.notice = "",
    this.url = "",
    this.artistId = 0,
    this.noticeable = false,
    this.createdAt = "",
  });

  factory DataNotice.fromJson(Map<String, dynamic> json) {
    return DataNotice(
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
      return DateFormat('yyyy.M.d', 'ko_KR').format(dateTime);
    }else {
      return "";
    }
  }

}
