import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';


import '../AppRoutes/constants.dart';
import '../Models/ResponseModel.dart';
import 'init_dio.dart';
import 'network_utils.dart';

var sharedServiceManager = RemoteServices.singleton;

class RemoteServices {
  static var dio = initDio();

  RemoteServices._internal();

  static final RemoteServices singleton = RemoteServices._internal();

  factory RemoteServices() {
    return singleton;
  }

  List<Map>? get responseJson => null;

  /// GET requests
  Future<Tuple2<dynamic?, ResponseModel?>> createGetRequest({required ApiType typeOfEndPoint, Map<String, dynamic>? params}) async {
    if (await NetworkUtil.isNetworkConnected()) {
      final dio = Dio();
      String url = APIConstant.baseDomain +  APIConstant.getValue(typeOfEndPoint);


      try {
        final response = await dio.get(url);
        print(response.data);
        return Tuple2(response.data, null);
      } on DioError catch (e) {
        return Tuple2(null,  createErrorResponse(status: APIConstant.statusCodeBadGateway, message: e.message));
      }
    } else {
      return Tuple2(null, createErrorResponse(status: APIConstant.statusCodeServiceNotAvailable, message: 'No Internet'));
    }
  }

  /// POST requests
  Future<Tuple2<Map<String, dynamic>?, ResponseModel?>> createPostRequest({required ApiType typeOfEndPoint, Map<String, dynamic>? params, String? urlParam}) async {
    if (await NetworkUtil.isNetworkConnected()) {
      final url = APIConstant.getValue(typeOfEndPoint);
      /*
      * item1 => API End-Point
      * item2 => Header
      * item3 => Request Param
      * item4 => Multipart file
      * */
      try {
        Response response = await dio.post(url, data: params);
        final Map<String, dynamic> responseJson = json.decode(response.data.toString());
        return Tuple2(responseJson, null);
      } on DioError catch (e) {
        return Tuple2(null,  createErrorResponse(status: APIConstant.statusCodeBadGateway, message: e.message));
      }
    } else {
      return Tuple2(null, createErrorResponse(status: APIConstant.statusCodeServiceNotAvailable, message: 'No Internet'));
    }
  }

  /// PUT requests
  // Future<Map<String, dynamic>> createPutRequest<T>({required ApiType typeOfEndPoint, Map<String, dynamic>? params, String? urlParam}) async {
  //   if (await NetworkUtil.isNetworkConnected()) {
  //     final requestFinal = ApiConstant.requestParamsForSync(typeOfEndPoint, params: params, urlParams: urlParam);
  //     /*
  //     * item1 => API End-Point
  //     * item2 => Header
  //     * item3 => Request Param
  //     * item4 => Multipart file
  //     * */
  //     try {
  //       Response response = await dio.put(requestFinal.item1, data: requestFinal.item3, options: Options(headers: requestFinal.item2));
  //
  //       return response;
  //     } on DioError catch (e) {
  //       return createErrorResponse(status: ApiConstant.statusCodeBadGateway, message: e.message);
  //     }
  //   } else {
  //     return createErrorResponse(status: ApiConstant.statusCodeServiceNotAvailable, message: StringConstant.noInternetMsg);
  //   }
  // }

  /// DELETE requests
   Future<Tuple2<Map<String, dynamic>?, ResponseModel?>> createDeleteRequest<T>({required ApiType typeOfEndPoint, Map<String, dynamic>? params, String? urlParam}) async {
    if (await NetworkUtil.isNetworkConnected()) {
      final url = APIConstant.getValue(typeOfEndPoint);
      /*
      * item1 => API End-Point
      * item2 => Header
      * item3 => Request Param
      * item4 => Multipart file
      * */
      try {
        Response response = await dio.post(url, data: params);
        final Map<String, dynamic> responseJson = json.decode(response.data.toString());
        return Tuple2(responseJson, null);
      } on DioError catch (e) {
        return Tuple2(null,  createErrorResponse(status: APIConstant.statusCodeServiceNotAvailable, message: e.message));
      }
    } else {
      return Tuple2(null, createErrorResponse(status: APIConstant.statusCodeServiceNotAvailable, message: 'No Internet'));
    }
  }

  ResponseModel createErrorResponse<T>({required int status, required String message}) {
    return ResponseModel(status: status, message: message);
  }

  // Future<ResponseModel<T>> uploadRequest<T>(ApiType apiType, {Map<String, dynamic>? params, List<AppMultiPartFile>? arrFile, String? urlParam}) async {
  //   if (await NetworkUtil.isNetworkConnected()) {
  //     final requestFinal = ApiConstant.requestParamsForSync(apiType, params: params, arrFile: arrFile ?? []);
  //
  //     Map<String, dynamic> other = <String, dynamic>{};
  //     other.addAll(requestFinal.item3);
  //
  //     /* Adding File Content */
  //     for (AppMultiPartFile partFile in requestFinal.item4) {
  //       List<MultipartFile> uploadFiles = [];
  //       for (File file in partFile.localFiles ?? []) {
  //         String filename = basename(file.path);
  //
  //         /// PDF Media
  //         if (filename.toLowerCase().contains(".pdf")) {
  //           MultipartFile mFile = await MultipartFile.fromFile(file.path, filename: filename);
  //           uploadFiles.add(mFile);
  //         }
  //
  //         /// Video Media
  //         else if (filename.toLowerCase().contains(".mp4") || filename.toLowerCase().contains(".mov") || filename.toLowerCase().contains(".mkv")) {
  //           MultipartFile mFile = await MultipartFile.fromFile(file.path, filename: filename, contentType: MediaType('video', filename.split(".").last));
  //           uploadFiles.add(mFile);
  //         }
  //
  //         /// Image Media
  //         else {
  //           MultipartFile mFile = await MultipartFile.fromFile(file.path, filename: filename, contentType: MediaType('image', filename.split(".").last));
  //           uploadFiles.add(mFile);
  //         }
  //       }
  //       if (uploadFiles.isNotEmpty) {
  //         other[partFile.key ?? ""] = (uploadFiles.length == 1) ? uploadFiles.first : uploadFiles;
  //       }
  //     }
  //
  //     FormData formData = FormData.fromMap(other);
  //     final option = Options(headers: requestFinal.item2);
  //
  //     try {
  //       final response = await dio.post(
  //         requestFinal.item1,
  //         data: formData,
  //         options: option,
  //         onSendProgress: (sent, total) {
  //           var progress = sent / total;
  //           Logger().v("uploadFile $progress");
  //         },
  //       );
  //
  //       return ResponseModel<T>.fromJson(json.decode(response.data.toString()), response.statusCode);
  //     } on DioError catch (error) {
  //       return createErrorResponse(status: ApiConstant.statusCodeBadGateway, message: error.message);
  //     }
  //   } else {
  //     return createErrorResponse(status: ApiConstant.statusCodeServiceNotAvailable, message: StringConstant.noInternetMsg);
  //   }
  // }
}
