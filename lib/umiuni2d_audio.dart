import 'dart:async';
import 'package:flutter/services.dart' as service;
import 'dart:io';

class Umiuni2dAudio {
  static const service.MethodChannel _channel =
  const service.MethodChannel('umiuni2d_audio');

  Future<String> platformVersion() async {
    return _channel.invokeMethod('getPlatformVersion');
  }

  Future<String> getPath() async {
    return _channel.invokeMethod('getPath');
  }

  Future<String> getAssetPath(String key) async {
    String path = (await getPath()).replaceAll(new RegExp(r"/$"), "");
    String keyPath = (await getPath()).replaceAll(new RegExp(r"^/"), "");
    return path +"/assets/"+keyPath;;
  }

  Future<String> prepareAssetPath(String key) async {
    String path = await getAssetPath(key);
    String dir = path.replaceAll(new RegExp(r"/[^/]*$"), path);
    await (new Directory(dir)).create(recursive: true);
    return path;
  }

  Future<Umiuni2dAudio> setupFromAssets(String key) async {
    String outputPath = await prepareAssetPath(key);
    service.AssetBundle bundle =  (service.rootBundle != null) ? service.rootBundle : new service.NetworkAssetBundle(new Uri.directory(Uri.base.origin));
    service.ByteData data = await bundle.load(key);
    File output = new File(outputPath);
    await output.writeAsBytes(data.buffer.asUint8List(),flush: true);
    return this;
  }

  Future<String> load(String key) async {
    String path = await getAssetPath(key);
    return _channel.invokeMethod('load',[path]);
  }

  Future<String> play() async {
    return _channel.invokeMethod('play');
  }

  Future<String> pause() async {
    return _channel.invokeMethod('pause');
  }

  Future<String> stop() async {
    return _channel.invokeMethod('stop');
  }

  Future<String> seek(double currentTime) async {
    return _channel.invokeMethod('seek',[currentTime]);
  }

  Future<num> getCurentTime() async {
    return _channel.invokeMethod('getCurentTime');
  }

  Future<num> setVolume(num volume, num interval) async {
    return _channel.invokeMethod('setVolume', [volume, interval]);
  }

  Future<num> getVolume() async {
    return _channel.invokeMethod('getVolume');
  }
}
