part of 'home_bloc.dart';

enum ListAdverStatus { initial, loading, success, failure }

enum LoadmoreListAdverStatus { initial, loading, success, failure }

enum GetPointStatus { initial, loading, success, failure }

@immutable
class HomeState {
  const HomeState(
      {this.listAdverStatus = ListAdverStatus.initial,
      this.loadmoreListAdverStatus = LoadmoreListAdverStatus.initial,
      this.getPointStatus = GetPointStatus.initial,
      this.account,
      this.bannerList,
      this.totalPoint,
      this.listDataOfferWall});

  final ListAdverStatus listAdverStatus;
  final LoadmoreListAdverStatus loadmoreListAdverStatus;
  final List<Map<String, dynamic>>? listDataOfferWall;
  final dynamic account;
  final dynamic bannerList;
  final dynamic totalPoint;
  final GetPointStatus getPointStatus;

  HomeState copyWith(
      {ListAdverStatus? listAdverStatus,
      LoadmoreListAdverStatus? loadmoreListAdverStatus,
      List<Map<String, dynamic>>? listDataOfferWall,
      GetPointStatus? getPointStatus,
      dynamic account,
      dynamic bannerList,
      dynamic totalPoint}) {
    return HomeState(
        getPointStatus: getPointStatus ?? this.getPointStatus,
        listAdverStatus: listAdverStatus ?? this.listAdverStatus,
        loadmoreListAdverStatus: loadmoreListAdverStatus ?? this.loadmoreListAdverStatus,
        listDataOfferWall: listDataOfferWall ?? this.listDataOfferWall,
        account: account ?? this.account,
        totalPoint: totalPoint ?? this.totalPoint,
        bannerList: bannerList ?? this.bannerList);
  }
}
