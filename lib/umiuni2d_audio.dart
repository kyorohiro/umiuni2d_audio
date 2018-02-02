import 'dart:async';
import 'package:flutter/services.dart' as service;
import 'dart:io';

class Umiuni2dMedia {
  static const service.MethodChannel _channel = const service.MethodChannel('umiuni2d_audio');
  static service.MethodChannel get channel => _channel;

  Future<String> platformVersion() async {
    return _channel.invokeMethod('getPlatformVersion');
  }

  Future<String> getPath() async {
    return _channel.invokeMethod('getPath');
  }

  Future<String> getAssetPath(String key) async {
    String path = (await getPath()).replaceAll(new RegExp(r"/$"), "");
    String keyPath = (await getPath()).replaceAll(new RegExp(r"^/"), "");
    return path + "/assets/" + keyPath;;
  }

  Future<String> prepareAssetPath(String key) async {
    String path = await getAssetPath(key);
    String dir = path.replaceAll(new RegExp(r"/[^/]*$"), path);
    await (new Directory(dir)).create(recursive: true);
    return path;
  }
  Future<Umiuni2dMedia> setupFromAssets(String key) async {
    String outputPath = await prepareAssetPath(key);
    service.AssetBundle bundle =  (service.rootBundle != null) ? service.rootBundle : new service.NetworkAssetBundle(new Uri.directory(Uri.base.origin));
    service.ByteData data = await bundle.load(key);
    File output = new File(outputPath);
    await output.writeAsBytes(data.buffer.asUint8List(),flush: true);
    return this;
  }
  Future<Umiuni2dAudio> load(String key) async {
    String path = await getAssetPath(key);
    String ret = await _channel.invokeMethod('load',[path]);
    return new Umiuni2dAudio();
  }
}


class Umiuni2dAudio {
  Umiuni2dAudio();
  Future<String> play() async {
    return Umiuni2dMedia._channel.invokeMethod('play');
  }

  Future<String> pause() async {
    return Umiuni2dMedia.channel.invokeMethod('pause');
  }

  Future<String> stop() async {
    return Umiuni2dMedia.channel.invokeMethod('stop');
  }

  Future<String> seek(double currentTime) async {
    return Umiuni2dMedia.channel.invokeMethod('seek',[currentTime]);
  }

  Future<num> getCurentTime() async {
    return Umiuni2dMedia.channel.invokeMethod('getCurentTime');
  }

  Future<num> setVolume(num volume, num interval) async {
    return Umiuni2dMedia.channel.invokeMethod('setVolume', [volume, interval]);
  }

  Future<num> getVolume() async {
    return Umiuni2dMedia.channel.invokeMethod('getVolume');
  }
}
