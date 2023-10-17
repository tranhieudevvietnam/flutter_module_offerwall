part of 'status_point_bloc.dart';

enum LoadListPointStatus { initial, loading, success, failure }

enum LoadMoreListPointStatus { initial, loading, success, failure }

class StatusPointState extends Equatable {
  const StatusPointState(
      {this.loadListPointStatus = LoadListPointStatus.initial,
      this.loadMoreListPointStatus = LoadMoreListPointStatus.initial,
      this.dataPoint,
      this.dataTotalPoint,
      this.totalPoint,
      this.dataPointOutsideAdvertising});
  final LoadListPointStatus loadListPointStatus;
  final LoadMoreListPointStatus loadMoreListPointStatus;
  final dynamic dataPointOutsideAdvertising;
  final dynamic dataPoint;
  final dynamic dataTotalPoint;
  final dynamic totalPoint;

  StatusPointState copyWith(
      {LoadListPointStatus? loadListPointStatus,
      LoadMoreListPointStatus? loadMoreListPointStatus,
      dynamic dataPoint,
      dynamic dataTotalPoint,
      dynamic totalPoint,
      dynamic dataPointOutsideAdvertising}) {
    return StatusPointState(
        totalPoint: totalPoint ?? this.totalPoint,
        loadListPointStatus: loadListPointStatus ?? this.loadListPointStatus,
        loadMoreListPointStatus:
            loadMoreListPointStatus ?? this.loadMoreListPointStatus,
        dataPoint: dataPoint ?? this.dataPoint,
        dataTotalPoint: dataTotalPoint ?? this.dataTotalPoint,
        dataPointOutsideAdvertising:
            dataPointOutsideAdvertising ?? this.dataPointOutsideAdvertising);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        loadListPointStatus,
        loadMoreListPointStatus,
        dataPointOutsideAdvertising,
        dataPoint,
        dataTotalPoint,
        totalPoint
      ];
}
