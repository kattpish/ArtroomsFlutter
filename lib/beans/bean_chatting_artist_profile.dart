
import 'package:intl/intl.dart';


class ArtistProfile {
  // id: 1, feedback: 가능, classAdvice: 가능 , ableDay: 월, ableTime: 10시, replyTime: 보통, artistId: 46
  int id ;
  String feedback;
  String classAdvice;
  String ableDay;
  String ableTime;
  String replyTime;
  int artistId;

  ArtistProfile({
    this.id = 0,
    this.feedback = "",
    this.classAdvice = "",
    this.ableDay = "",
    this.ableTime = "",
    this.replyTime = "",
    this.artistId = 0,
  });

  factory ArtistProfile.fromJson(Map<String, dynamic> json) {
    return ArtistProfile(
      id: json['id'] as int,
      feedback: json['feedback'] as String,
      classAdvice: json['classAdvice'] as String,
      ableDay: json['ableDay'] as String,
      ableTime: json['ableTime'] as String,
      replyTime: json['replyTime'] as String,
      artistId: json['artistId'] as int,
    );
  }

}
