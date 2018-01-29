import 'package:flutter/material.dart' as sky;
import 'package:flutter/services.dart';
import 'package:umiuni2d_audio/umiuni2d_audio.dart';
import 'dart:async';
import 'dart:io' as io;
void main() => sky.runApp(new MyApp());

class MyApp extends sky.StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends sky.State<MyApp> {
  Umiuni2dAudio _player;
  String _message = 'Unknown';

  _MyAppStat() {
  }

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    _player = new Umiuni2dAudio();

    new Future.delayed(new Duration(seconds: 0)).then((dynamic d) async {
      String message = "";
      try {
        await _player.setupFromAssets("assets/bgm_maoudamashii_acoustic09.mp3");
        String assetPath = await _player.getAssetPath("assets/bgm_maoudamashii_acoustic09.mp3");
        if(await (new io.File(assetPath)).exists()) {
          message += "# exist" + '\r\n';
        } else {
          message += "# no exist" + '\r\n';
        }
        message += await _player.load("assets/bgm_maoudamashii_acoustic09.mp3");
      } catch (e) {
        message += "# " + e.toString() + '\r\n';
      }

      if (!mounted)
        return;

      setState(() {
        _message = message;
      });
    });

  }

  @override
  sky.Widget build(sky.BuildContext context) {
    return new sky.MaterialApp(
      home: new sky.Scaffold(
        appBar: new sky.AppBar(
          title: new sky.Text('Umiuni2D Audio Test'),
        ),
        body: new sky.Center(
          child: new sky.Column(
              mainAxisAlignment: sky.MainAxisAlignment.spaceEvenly,
              children: <sky.Widget>[
                new sky.Text('Running on: $_message\n'),
                new sky.Row(
                  mainAxisAlignment: sky.MainAxisAlignment.spaceEvenly,
                  children: <sky.Widget>[
                    buildButtonColumn('Play'),
                    buildButtonColumn('Pause'),
                    buildButtonColumn('Stop'),
                  ]
                ),
                new sky.Row(
                    mainAxisAlignment: sky.MainAxisAlignment.spaceEvenly,
                    children: <sky.Widget>[
                      buildButtonColumn('+5s'),
                      buildButtonColumn('-5s'),
                    ]
                ),
                new sky.Row(
                    mainAxisAlignment: sky.MainAxisAlignment.spaceEvenly,
                    children: <sky.Widget>[
                      buildButtonColumn('Volume up'),
                      buildButtonColumn('Volume down'),
                    ]
                )
              ]// new sky.Text('Running on: $_message\n'),
          )
        ),
      ),
    );
  }

  Future<_MyAppState> onClick(String label) async {

    if (!mounted) {
      return this;
    }

    if(label == "Play") {
      String message = "";
      try {
        message += await _player.play();
      } catch (e) {
        message +=  e.toString() + '\r\n';
      }
      setState(() {
        _message = message;
      });
      return this;
    }
    if(label == "Pause") {
      String message = "";
      try {
        message += await _player.pause();
      } catch (e) {
        message +=  e.toString() + '\r\n';
      }

      setState(() {
        _message = message;
      });
      return this;
    }
    if(label == "Stop") {
      String message = "";
      try {
        message += await _player.stop();
      } catch (e) {
        message +=  e.toString() +'.\r\n';
      }

      setState(() {
        _message = message;
      });
      return this;
    }
    if(label == "+5s") {
      String message = "";
      try {
        message += await _player.seek(await _player.getCurentTime()+5.0);
      } catch (e) {
        message +=  e.toString() +'.\r\n';
      }

      setState(() {
        _message = message;
      });
      return this;
    }
    if(label == "-5s") {
      String message = "";
      try {
        message += await _player.seek(await _player.getCurentTime()-5.0);
      } catch (e) {
        message +=  e.toString() +'.\r\n';
      }

      setState(() {
        _message = message;
      });
      return this;
    }
    if(label == 'volume up') {
      String message = "";
      try {
        message += await _player.seek(await _player.getCurentTime()-5.0);
      } catch (e) {
        message +=  e.toString() +'.\r\n';
      }

      setState(() {
        _message = message;
      });
      return this;
    }
    if(label == 'Volume down') {
      String message = "";
      try {
        await _player.setVolume(await _player.getVolume()-0.1, 1.0);
        message += ""+(await _player.getVolume()).toString();
      } catch (e) {
        message +=  e.toString() +'.\r\n';
      }

      setState(() {
        _message = message;
      });
      return this;
    }
    if(label == 'Volume up') {
      String message = "";
      try {
        await _player.setVolume(await _player.getVolume()+0.1, 1.0);
        message += ""+(await _player.getVolume()).toString();
      } catch (e) {
        message +=  e.toString() +'.\r\n';
      }

      setState(() {
        _message = message;
      });
      return this;
    }
    return this;
  }

  sky.Column buildButtonColumn(String label) {
    sky.Color color = sky.Theme.of(context).primaryColor;
    return new sky.Column(
      mainAxisSize: sky.MainAxisSize.min,
      mainAxisAlignment: sky.MainAxisAlignment.center,
      children: [
        new sky.Container(
          margin: const sky.EdgeInsets.only(top: 8.0),
          child: new sky.RaisedButton(
            onPressed: (){onClick(label);},
            child: new sky.Text(
              label,
              style: new sky.TextStyle(
                fontSize: 12.0,
                fontWeight: sky.FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

