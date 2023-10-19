import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://nb.tata.kg/api/v1/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? lang = 'en',
    String? token,
  }) async {
    Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        'lang': lang,
        'Authorization': 'Bearer $token',
      },
      validateStatus: (_) => true,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    return await dio.get(url, queryParameters: query, options: options);
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    String? lang = 'en',
    String? token,
  }) async {
    Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        'lang': lang,
        'Authorization': 'Bearer $token',
      },
      validateStatus: (statusCode){
        if(statusCode == null){
          return false;
        }
        if(statusCode == 422){ // your http status code
          return true;
        }else{
          return statusCode >= 200 && statusCode < 300;
        }
      },
      // validateStatus: (_) => true,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': 'Bearer $token',
    // "Accept":"application/json",
    };
    Options(
      // validateStatus: (status) { return status! < 500; },
      contentType: Headers.jsonContentType,
      responseType:ResponseType.json,
      followRedirects: false,
      validateStatus: (statusCode){
        if(statusCode == null){
          return false;
        }
        if(statusCode == 422){ // your http status code
          return true;
        }else{
          return statusCode >= 200 && statusCode < 300;
        }
      },
    );
    return await dio.post(url, data: data);
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    String? lang = 'en',
    String? token,
  }) async {
    Options options = Options(
      headers: {
        'Content-Type': 'multipart/form-data',
        'lang': lang,
        'Authorization': 'Bearer $token',
      },
      validateStatus: (_) => true,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    return await dio.put(url, data: data, options: options);
  }

  static Future<Response> postDataWithImages({
    required String url,
    required Map<String, dynamic> data,
    String? lang = 'en',
    dynamic token,
    dynamic document_front,
    dynamic document_back,
  }) async {
    Options options = Options(
      headers: {
        'Content-Type': 'multipart/form-data',
        'lang': lang,
        'Authorization': 'Bearer $token',
      },
      validateStatus: (_) => true,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    FormData formData = FormData.fromMap(data);

    if (document_front != null) {
      formData.files.add(MapEntry(
        "image1",
        await MultipartFile.fromFile(document_front, filename: 'image1.jpg'),
      ));
    }

    if (document_back != null) {
      formData.files.add(MapEntry(
        "image2",
        await MultipartFile.fromFile(document_back, filename: 'image2.jpg'),
      ));
    }

    return await dio.post(url, data: formData, options: options);
  }




  static Future<Response> deleteData({
    required String url,
    String? lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': 'Bearer $token',
      // "Accept":"application/json",
    };
    Options(
      // validateStatus: (status) { return status! < 500; },
      contentType: Headers.jsonContentType,
      responseType:ResponseType.json,
      followRedirects: false,
      validateStatus: (statusCode){
        if(statusCode == null){
          return false;
        }
        if(statusCode == 422){ // your http status code
          return true;
        }else{
          return statusCode >= 200 && statusCode < 300;
        }
      },
    );

    return await dio.delete(url);
  }

}
