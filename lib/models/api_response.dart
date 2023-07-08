class ApiResponse<T> {
  int status;
  T data;
  String message;

  ApiResponse(
      {required this.status, required this.data, required this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      data: json['data'],
      message: json['message'],
    );
  }
}
