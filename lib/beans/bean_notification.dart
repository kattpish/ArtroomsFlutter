

class Notice {

  final int index;
  final String date;
  final String title;
  final String body;
  bool isAdmin;

  Notice(
      this.index,
      this.date,
      this.title,
      this.body,
      {
        this.isAdmin = true
      }
      );

}
