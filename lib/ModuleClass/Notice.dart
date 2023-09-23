class Notice {
  String date, notice, title;
  Notice({required this.date, required this.title, required this.notice});
  String getDate() {
    return this.date;
  }

  String getTitle() {
    return this.title;
  }

  String getNotice() {
    return this.notice;
  }
}
