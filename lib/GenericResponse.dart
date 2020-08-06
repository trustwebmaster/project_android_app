class GenRes {
  String message;
  String success;

  GenRes({this.message, this.success});

  factory GenRes.fromJson(Map<String, dynamic> json) {
    return GenRes(
      message: json['message'] as String,
      success: json['success'] as String,
    );
  }
}
