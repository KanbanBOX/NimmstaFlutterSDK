import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:nimmsta_sdk/models/scan_picking_mode.dart';
import 'package:nimmsta_sdk/models/scan_trigger_mode.dart';

class NimmstaSdk {
  static const MethodChannel _channel = const MethodChannel("nimmsta_sdk_methods");

  final void Function() didConnectAndInitCallback;
  final void Function() didDisconnectCallback;
  final void Function(dynamic) didTouchCallback;
  final void Function(dynamic) didClickButtonCallback;
  final void Function(dynamic) didScanBarcodeCallback;

  NimmstaSdk(
      {this.didConnectAndInitCallback, this.didDisconnectCallback, this.didTouchCallback, this.didClickButtonCallback, this.didScanBarcodeCallback}) {
    _channel.setMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'didConnectAndInit':
          this.didConnectAndInitCallback();
          break;
        case 'didDisconnect':
          this.didDisconnectCallback();
          break;
        case 'didTouch':
          this.didTouchCallback(methodCall.arguments);
          break;
        case 'didClickButton':
          this.didClickButtonCallback(methodCall.arguments);
          break;
        case 'didScanBarcode':
          this.didScanBarcodeCallback(methodCall.arguments);
          break;
        default:
          throw MissingPluginException('notImplemented');
      }
    });
  }

  /// Shows a screen that permits to connect a Nimmsta device scanning a QrCode
  Future<bool> isConnected() async {
    return await _channel.invokeMethod<bool>("isConnected");
  }

  /// Shows a screen that permits to connect a Nimmsta device scanning a QrCode
  Future<void> connect() async {
    return await _channel.invokeMethod("connect");
  }

  /// Disconnect a Nimmsta device if it's connected
  Future<void> disconnect() async {
    return await _channel.invokeMethod("disconnect");
  }

  Future<void> setLayout(String layoutResource, Map<String, String> dataToInject) async {
    return await _channel.invokeMethod<void>("setLayout", <String, dynamic>{
      'layoutResource': layoutResource,
      'dataToInject': dataToInject,
    });
  }

  /// Changes given screen info with the given ones
  /// Only given keys will update, the others will remain to previous value
  Future<void> setScreenInfoAsync(Map<String, String> dataToInject) async {
    return await _channel.invokeMethod("setScreenInfoAsync", dataToInject);
  }

  Future<void> pushSettings(
      bool prefersReconnect, bool prefersShutdownOnCharge, ScanTriggerMode preferredTriggerMode, ScanPickingMode preferredPickingMode) async {
    return await _channel.invokeMethod("pushSettings", {
      "settings": {
        "prefersReconnect": prefersReconnect.toString(),
        "prefersShutdownOnCharge": prefersShutdownOnCharge.toString(),
        "preferredTriggerMode": preferredTriggerMode.toString(),
        "preferredPickingMode": preferredPickingMode.toString()
      }
    });
  }

  Future<void> setLEDColor(Color color) async {
    return await _channel.invokeMethod("setLEDColor", {
      "r": color.red,
      "g": color.green,
      "b": color.blue,
    });
  }

  Future<void> triggerLEDBurst(int repeat, int duration, int pulseDuration, Color color) async {
    return await _channel.invokeMethod("triggerLEDBurst", {
      "repeat": repeat,
      "duration": duration,
      "pulseDuration": pulseDuration,
      "r": color.red,
      "g": color.green,
      "b": color.blue,
    });
  }

  Future<void> triggerVibrationBurst(int repeat, int duration, int pulseDuration, int intensity) async {
    return await _channel.invokeMethod("triggerVibrationBurst", {
      "repeat": repeat,
      "duration": duration,
      "pulseDuration": pulseDuration,
      "intensity": intensity,
    });
  }

  Future<void> triggerBeeperBurst(int repeat, int duration, int pulseDuration, int intensity) async {
    return await _channel.invokeMethod("triggerBeeperBurst", {
      "repeat": repeat,
      "duration": duration,
      "pulseDuration": pulseDuration,
      "intensity": intensity,
    });
  }
}
