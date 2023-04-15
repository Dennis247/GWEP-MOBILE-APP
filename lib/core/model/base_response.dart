class BaseResponse {
  BaseResponse(
      {required this.data, required this.succeeded, required this.message});
  late final dynamic data;
  late final bool succeeded;
  late final String message;

  BaseResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    succeeded = json['succeeded'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['data'] = data;
    data['succeeded'] = succeeded;
    data['message'] = message;
    return data;
  }
}
