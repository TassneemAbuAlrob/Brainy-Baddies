import 'package:flutter/services.dart';

Future<String> getUniqueId() async{
  MethodChannel channel = const MethodChannel('brainy_channel');

  String id = await channel.invokeMethod('getAndroidId');

  return id;
}