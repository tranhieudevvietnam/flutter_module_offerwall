import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/instance_manager.dart';
// import 'package:jiffy/jiffy.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:eums/eum_app_offer_wall/screen/status_point_module/bloc/status_point_bloc.dart';
import 'package:eums/eum_app_offer_wall/utils/appStyle.dart';
import 'package:eums/eum_app_offer_wall/utils/hex_color.dart';
import 'package:eums/eum_app_offer_wall/utils/loading_dialog.dart';
import 'package:eums/eum_app_offer_wall/widget/setting_fontsize.dart';
import 'package:eums/gen/assets.gen.dart';

import '../../../common/constants.dart';

enum Units { MILLISECOND, SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, YEAR }

class StatusPointPage extends StatefulWidget {
  const StatusPointPage({Key? key, this.account, this.tabCount}) : super(key: key);
  final dynamic account;
  final int? tabCount;

  @override
  State<StatusPointPage> createState() => _StatusPointPageState();
}

class _StatusPointPageState extends State<StatusPointPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<State<StatefulWidget>> globalKey = GlobalKey<State<StatefulWidget>>();
  late TabController _tabController;

  DateTime firstMonth = DateTime.now();
  dynamic account;

  dynamic countPoint;
  dynamic totalPointEum = 0;
  int totalPointOfferWall = 0;
  int tabIndex = 0;
  int tabPreviousIndex = 0;
  final controllerGet = Get.put(SettingFontSize());

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    account = widget.account;
    _tabController.addListener(_onTabChange);
    if (widget.tabCount == 1) {
      _tabController.animateTo(widget.tabCount ?? 0);
    }
    super.initState();
  }

  _onTabChange() {
    tabIndex = _tabController.index;
    if (tabIndex != tabPreviousIndex) {
      _fetchData();
    }
    tabPreviousIndex = _tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatusPointBloc>(
      create: (context) => StatusPointBloc()
        ..add(GetPoint())
        ..add(ListPoint(limit: 10, month: firstMonth.month, year: firstMonth.year))
        ..add(PointOutsideAdvertisinglList(month: firstMonth.month, year: firstMonth.year)),
      child: MultiBlocListener(
        listeners: [
          BlocListener<StatusPointBloc, StatusPointState>(
            listenWhen: (previous, current) => previous.loadListPointStatus != current.loadListPointStatus,
            listener: _listenFetchDataLoadMore,
          ),
          BlocListener<StatusPointBloc, StatusPointState>(
            listenWhen: (previous, current) => previous.loadMoreListPointStatus != current.loadMoreListPointStatus,
            listener: _listenFetchData,
          ),
        ],
        child: _buildContent(context),
      ),
    );
  }

  void _listenFetchData(BuildContext context, StatusPointState state) {
    if (state.loadMoreListPointStatus == LoadMoreListPointStatus.loading) {
      LoadingDialog.instance.show();
      return;
    }
    if (state.loadMoreListPointStatus == LoadMoreListPointStatus.failure) {
      LoadingDialog.instance.hide();
      return;
    }
    if (state.loadMoreListPointStatus == LoadMoreListPointStatus.success) {
      LoadingDialog.instance.hide();
    }
  }

  void _listenFetchDataLoadMore(BuildContext context, StatusPointState state) {
    if (state.loadListPointStatus == LoadListPointStatus.loading) {
      LoadingDialog.instance.show();
      return;
    }
    if (state.loadListPointStatus == LoadListPointStatus.failure) {
      LoadingDialog.instance.hide();
      return;
    }
    if (state.loadListPointStatus == LoadListPointStatus.success) {
      LoadingDialog.instance.hide();
    }
  }

  _fetchData() async {
    await Future.delayed(const Duration(seconds: 0));

    if (_tabController.index == 0) {
      globalKey.currentContext?.read<StatusPointBloc>().add(ListPoint(limit: 10, month: firstMonth.month, year: firstMonth.year));
    } else {
      globalKey.currentContext?.read<StatusPointBloc>().add(PointOutsideAdvertisinglList(month: firstMonth.month, year: firstMonth.year));
    }
  }

  void _onLoading(
    int? offset,
  ) async {
    await Future.delayed(const Duration(seconds: 0));

    if (_tabController.index == 0) {
      globalKey.currentContext
          ?.read<StatusPointBloc>()
          .add(LoadMoreListPoint(limit: 10, offset: offset, month: firstMonth.month, year: firstMonth.year));
    }
  }

  _buildContent(BuildContext context) {
    return Scaffold(
        key: globalKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('포인트 현황', style: AppStyle.bold.copyWith(color: Colors.black, fontSize: 4 + controllerGet.fontSizeObx.value)),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
          ),
        ),
        body: BlocBuilder<StatusPointBloc, StatusPointState>(
          builder: (context, state) {
            return Column(
              children: [
                TabBar(
                  onTap: (value) {
                    int index = value;
                    setState(() {
                      _tabController.index = index;
                      _fetchData();
                    });
                  },
                  labelPadding: const EdgeInsets.only(bottom: 10, top: 10),
                  controller: _tabController,
                  indicatorColor: HexColor('#f4a43b'),
                  unselectedLabelColor: HexColor('#707070'),
                  labelColor: HexColor('#f4a43b'),
                  labelStyle: AppStyle.bold.copyWith(color: HexColor('#707070')),
                  tabs: [
                    Text(
                      '포인트 적립 내역',
                      style: AppStyle.regular.copyWith(fontSize: controllerGet.fontSizeObx.value),
                    ),
                    Text(
                      ' 포인트 전환',
                      style: AppStyle.regular.copyWith(fontSize: controllerGet.fontSizeObx.value),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '현재 보유 포인트',
                            style: AppStyle.medium.copyWith(color: HexColor('707070'), fontSize: controllerGet.fontSizeObx.value),
                          ),
                          Row(
                            children: [
                              Image.asset(Assets.icon_point_y.path, package: "eums", height: 24),
                              const SizedBox(width: 8),
                              Text(
                                Constants.formatMoney(state.dataTotalPoint != null ? state.dataTotalPoint['totalPoint'] : 0, suffix: '원'),
                                style: AppStyle.bold.copyWith(fontSize: controllerGet.fontSizeObx.value),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: HexColor('#fcc900')),
                        child: Text('소멸예정', style: AppStyle.bold.copyWith(fontSize: controllerGet.fontSizeObx.value - 2)),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 7, color: HexColor('#f4f4f4')),
                _buildWidgetDate(),
                BlocBuilder<StatusPointBloc, StatusPointState>(
                  builder: (context, state) {
                    totalPointEum = 0;
                    totalPointOfferWall = 0;
                    try {
                      if (_tabController.index == 0) {
                        if (state.dataPoint != null && state.dataPoint.length > 0) {
                          for (int i = 0; i < state.dataPoint.length; i++) {
                            totalPointEum = totalPointEum + state.dataPoint[i]['user_point'];
                          }
                        }
                      } else {
                        if (state.dataPointOutsideAdvertising != null && state.dataPointOutsideAdvertising.length > 0) {
                          for (int i = 0; i < state.dataPointOutsideAdvertising.length; i++) {
                            totalPointOfferWall = totalPointOfferWall + int.parse(state.dataPointOutsideAdvertising[i]['point'].toString());
                          }
                        }
                      }
                    } catch (ex) {}

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12), color: _tabController.index == 0 ? HexColor('#f4f4f4') : HexColor('#fdde4c')),
                      child: Column(
                        children: [
                          Text(
                            _tabController.index == 0 ? '총 누적 적립 포인트' : '현재까지 캐시로 전환된 포인트',
                            style: AppStyle.regular.copyWith(fontSize: controllerGet.fontSizeObx.value),
                            textAlign: TextAlign.center,
                          ),
                          Text(Constants.formatMoney(_tabController.index == 0 ? state.totalPoint ?? 0 : totalPointOfferWall, suffix: '원'),
                              style: AppStyle.bold.copyWith(fontSize: 8 + controllerGet.fontSizeObx.value)),
                        ],
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                    child: TabBarView(controller: _tabController, children: [
                      ListViewPointPage(
                        tab: _tabController.index,
                        fetchData: _fetchData,
                        fetchDataLoadMore: _onLoading,
                      ),
                      ListViewPointPage(
                        tab: _tabController.index,
                        fetchData: _fetchData,
                        fetchDataLoadMore: _onLoading,
                      )
                    ]),
                  ),
                ),
                InkWell(
                    onTap: () {
                      dynamic offerset = globalKey.currentContext?.read<StatusPointBloc>().state.dataPoint.length;
                      _onLoading(offerset);
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: HexColor('#e5e5e5'))),
                        child: Text(
                          "더보기",
                          textAlign: TextAlign.center,
                          style: AppStyle.bold.copyWith(color: Colors.black, fontSize: controllerGet.fontSizeObx.value),
                        )))
              ],
            );
          },
        ));
  }

  _buildWidgetDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () {
                setState(() {
                  // firstMonth = DateTime.parse(
                  //     Jiffy.parseFromDateTime(firstMonth)
                  //         .startOf(Unit.month)
                  //         .subtract(months: 1)
                  //         .format(pattern: 'yyyy-MM-dd'));
                  firstMonth = DateTime(firstMonth.year, firstMonth.month - 1, firstMonth.day);

                  _fetchData();
                });
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
              )),
          Text(
            Constants.formatTimePoint(firstMonth.toString()),
            style: AppStyle.bold.copyWith(fontSize: 2 + controllerGet.fontSizeObx.value),
          ),
          InkWell(
              onTap: () {
                if (firstMonth.year <= DateTime.now().year && firstMonth.month < DateTime.now().month) {
                  setState(() {
                    // firstMonth = DateTime.parse(
                    //     Jiffy.parseFromDateTime(firstMonth)
                    //         .startOf(Unit.month)
                    //         .add(months: 1)
                    //         .format(pattern: 'yyyy-MM-dd'));

                    firstMonth = DateTime(firstMonth.year, firstMonth.month + 1, firstMonth.day);
                    _fetchData();
                  });
                }
              },
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
              )),
        ],
      ),
    );
  }
}

class ListViewPointPage extends StatefulWidget {
  const ListViewPointPage({
    Key? key,
    this.tab,
    this.fetchData,
    this.fetchDataLoadMore,
  }) : super(key: key);

  final int? tab;
  final Function? fetchData;
  final Function? fetchDataLoadMore;

  @override
  State<ListViewPointPage> createState() => _ListViewPointPageState();
}

class _ListViewPointPageState extends State<ListViewPointPage> {
  RefreshController refreshController = RefreshController(initialRefresh: false);
  final controllerGet = Get.put(SettingFontSize());
  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(seconds: 0));
    refreshController.refreshCompleted();
    setState(() {});
    widget.fetchData!();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 0));
    refreshController.loadComplete();
    // print('cos vao day k');
    List<dynamic>? dataCampaign = context.read<StatusPointBloc>().state.dataPoint;
    // print('cos vao day k$dataCampaign');
    if (dataCampaign != null) {
      widget.fetchDataLoadMore!(dataCampaign.length);
    }
  }

  _buildContent(BuildContext context) {
    return BlocBuilder<StatusPointBloc, StatusPointState>(
      builder: (context, state) {
        return SmartRefresher(
          controller: refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: state.dataPoint != null
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Wrap(
                      runSpacing: 20,
                      children:
                          List.generate(widget.tab == 0 ? state.dataPoint?.length ?? 0 : state.dataPointOutsideAdvertising?.length ?? 0, (index) {
                        String? title;
                        String? date;
                        int? point;

                        try {
                          title = widget.tab == 0
                              ? state.dataPoint[index]['advertise'] != null
                                  ? state.dataPoint[index]['advertise']['name']
                                  : ''
                              : state.dataPointOutsideAdvertising[index]['reason'];

                          date = widget.tab == 0
                              ? state.dataPoint[index] != null
                                  ? state.dataPoint[index]['regist_date']
                                  : ''
                              : state.dataPointOutsideAdvertising[index]['regist_date'];

                          point = widget.tab == 0
                              ? state.dataPoint[index] != null
                                  ? state.dataPoint[index]['user_point']
                                  : ''
                              : state.dataPointOutsideAdvertising[index]['point'];
                        } catch (ex) {}

                        return _buildItem(title: title, date: date, point: point);
                      }),
                    ),
                  ),
                )
              : const SizedBox(),
        );
      },
    );
  }

  _buildItem({String? title, String? date, int? point}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(shape: BoxShape.circle, color: HexColor('#888888').withOpacity(0.3)),
          child: Image.asset(Assets.icon_point.path, package: "eums", height: 25),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? '',
                style: AppStyle.medium.copyWith(fontSize: controllerGet.fontSizeObx.value),
              ),
              const SizedBox(height: 5),
              Text(
                '찾아가는 광고 ${Constants.formatTimeDayPoint(date)}',
                style: AppStyle.regular.copyWith(fontSize: controllerGet.fontSizeObx.value - 2, color: HexColor('#707070')),
              )

              ///  오퍼월 광고
            ],
          ),
        ),
        Text(
          Constants.formatMoney(point ?? 0, suffix: 'P'),
          style: AppStyle.bold.copyWith(fontSize: controllerGet.fontSizeObx.value),
        ),
      ],
    );
  }
}
