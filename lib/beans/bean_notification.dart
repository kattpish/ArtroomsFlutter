

class Notice {
  final String date;
  final String title;
  final String body;
  bool isVisible;

  Notice(
      this.date,
      this.title,
      this.body,
      {
        this.isVisible = true
      });

}
