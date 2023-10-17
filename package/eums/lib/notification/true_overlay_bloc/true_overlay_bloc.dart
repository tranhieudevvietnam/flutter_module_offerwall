import 'package:dio/dio.dart';
import 'package:eums/common/constants.dart';
import 'package:eums/common/local_store/local_store.dart';
import 'package:eums/common/local_store/local_store_service.dart';

class TrueOverlayService {
  LocalStore localStore = LocalStoreService();

  Dio dio = Dio();
  Future missionOfferWallOutside({advertiseIdx, pointType, token}) async {
    // bên ngoài
    dynamic data = <String, dynamic>{"advertise_idx": advertiseIdx, "pointType": pointType};

    await dio.post('${Constants.baseUrl}point/advertises/mission-complete',
        data: data, options: Options(headers: {"authorization": 'Bearer $token'}));
    return;
  }

  Future saveKeep({advertiseIdx, token}) async {
    dynamic data = <String, dynamic>{"advertise_idx": advertiseIdx};
    return await dio.post('${Constants.baseUrl}advertises/save-keep-advertise',
        data: data, options: Options(headers: {"authorization": 'Bearer $token'}));
  }

  Future saveScrap({advertiseIdx, token}) async {
    dynamic data = <String, dynamic>{"advertise_idx": advertiseIdx};
    await dio.post('${Constants.baseUrl}advertises/save-scrap-advertise', data: data, options: Options(headers: {"authorization": 'Bearer $token'}));
    return;
  }

  Future deleteScrap({advertiseIdx, token}) async {
    await dio.delete('${Constants.baseUrl}advertises/delete-crap/$advertiseIdx', options: Options(headers: {"authorization": 'Bearer $token'}));
  }
}
