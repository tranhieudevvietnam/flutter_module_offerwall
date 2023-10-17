import 'dart:async';

import 'package:flutter/material.dart';
import 'package:eums/common/local_store/local_store_service.dart';
import 'package:eums/eum_app_offer_wall/utils/appColor.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../utils/appStyle.dart';

class CustomWebViewJoin extends StatefulWidget {
  final dynamic urlLink;
  final dynamic title;
  final Function()? onSave;
  final Function()? mission;
  final Function onClose;
  final Color color;
  final Color colorIconBack;
  final Widget? actions;
  final Widget? bookmark;
  final showImage;
  const CustomWebViewJoin(
      {Key? key,
      this.urlLink,
      this.title,
      this.onSave,
      this.mission,
      this.colorIconBack = AppColor.black,
      this.color = AppColor.white,
      this.actions,
      required this.onClose,
      this.showImage = false,
      this.bookmark})
      : super(key: key);

  @override
  State<CustomWebViewJoin> createState() => _CustomWebViewJoinState();
}

class _CustomWebViewJoinState extends State<CustomWebViewJoin> {
  late final WebViewController _controller;
  bool isLoading = true;

  Timer? _timer;
  Timer? _timerHanlder;
  int _start = 15;
  int _startHanlder = 5;
  bool showButton = false;

  String getProperHtml(String content) {
    String start1 = 'https:';
    int startIndex1 = content.indexOf(start1);
    String iframeTag1 = content.substring(startIndex1 + 6);
    content = iframeTag1.replaceAll("$iframeTag1", "http:${iframeTag1}");
    return content;
  }

  double deviceWith = 0;
  getDeviceWidth() async {
    deviceWith = double.parse(await LocalStoreService().getDeviceWidth());
    print('deviceWithdeviceWith $deviceWith');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceWidth();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onUrlChange: (change) {},
          onWebResourceError: (WebResourceError error) {
            print("errorerror$error");
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith((widget.urlLink))) {
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse((widget.urlLink ?? '')));
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
    _controller = controller;
  }

  @override
  void dispose() {
    _timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.title, style: AppStyle.bold.copyWith(fontSize: 16)),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            if (widget.colorIconBack == AppColor.white) {
              Navigator.of(context).pop();
            } else {
              widget.onClose();
            }
          },
          child: Icon(Icons.arrow_back, color: widget.colorIconBack, size: 24),
        ),
        actions: [widget.actions ?? const SizedBox()],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
