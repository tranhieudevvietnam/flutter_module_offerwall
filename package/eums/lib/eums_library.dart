// declare a name for this library to reference from parts
// this is not necessary if we do not need to reference elsewhere
// NOTE: generally, a Dart file is a Library
library counter;

export 'package:device_preview/device_preview.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_messaging/firebase_messaging.dart';
export 'package:flutter_background_service/flutter_background_service.dart';
export 'package:flutter_overlay_window/flutter_overlay_window.dart';
export 'package:get/get.dart';
export 'package:eums/api_eums_offer_wall/eums_offer_wall_service.dart';
export 'package:eums/eum_app_offer_wall/eums_app_i.dart';
export 'package:eums/eum_app_offer_wall/my_home_screen.dart';
// export 'package:eums/eum_app_offer_wall/notification_handler.dart';
export 'package:eums/notification/true_caller_overlay.dart';
// export adds contents of another Library to this Library's namespace
// here we are adding all content (accessible from outside the library) from
// the material library
// NOTE: this is intended for related libraries
// this arbitrary usage is simply for demonstration purposes
export 'package:eums/eums.dart';
export 'package:eums/eums_permission.dart';


// for finer control, we can use the 'show' directive
// try this to see the effects of selected export
// export 'package:flutter/material.dart' show StatefulWidget, State;

// include any files containing parts of this library