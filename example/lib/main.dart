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
  Umiuni2dMedia _player;
  String _message = 'Unknown';

  Map<String,String> audioFiles = {
    "acoustic09.mp3":"assets/bgm_maoudamashii_acoustic09.mp3",
    "lastboss0.mp3":"assets/bgm_maoudamashii_lastboss0.mp3",
  };
  String radioValue = "lastboss0.mp3";
  _MyAppStat() {
  }

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    _player = new Umiuni2dMedia();

    new Future.delayed(new Duration(seconds: 0)).then((dynamic d) async {
      String message = "";
      try {
          //
        for(String key in  audioFiles.keys) {
          //await _player.getAssetPath(audioFiles[key]);
          await _player.setupFromAssets(audioFiles[key]);
          await _player.load(key, audioFiles[key]);
        }
        message += "# ok"+ '\r\n';
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


  void handleRadioValueChanged(String value) {
    setState(() {
      radioValue = value;
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
                  new sky.Row(
                  mainAxisAlignment: sky.MainAxisAlignment.spaceEvenly,
                  children: <sky.Widget>[
                    new sky.Text('#${audioFiles.keys.toList()[0]}\n'),
                    new sky.Radio<String>(
                        value: audioFiles.keys.toList()[0],
                        groupValue: radioValue,
                        onChanged: handleRadioValueChanged
                    ),
                    new sky.Text('#${audioFiles.keys.toList()[1]}\n'),
                    new sky.Radio<String>(
                        value: audioFiles.keys.toList()[1],
                        groupValue: radioValue,
                        onChanged: handleRadioValueChanged
                    ),
                    ]
                  ),
                new sky.Text('Running on: $_message\n'),
                new sky.Row(
                  mainAxisAlignment: sky.MainAxisAlignment.spaceEvenly,
                  children: <sky.Widget>[
                    buildButtonColumn('Play'),
                    buildButtonColumn('Pause'),
                  ]
                ),
                  new sky.Row(
                      mainAxisAlignment: sky.MainAxisAlignment.spaceEvenly,
                      children: <sky.Widget>[
                        buildButtonColumn('Load'),
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

    String message = "";
    Umiuni2dAudio _audio = _player.getAudio(radioValue);
    print("## ${_audio.id} ${_audio.path}");
      try {
      if(label == "Play") {
          message += await _audio.play();
      }
      if(label == "Load") {
          message += await _audio.load();
      }
      if(label == "Pause") {
          message += await _audio.pause();
      }
      if(label == "Stop") {
          message += await _audio.stop();
      }
      if(label == "+5s") {
          message += await _audio.seek(await _audio.getCurentTime()+5.0);
      }
      if(label == "-5s") {
          message += await _audio.seek(await _audio.getCurentTime()-5.0);
      }
      if(label == 'volume up') {
          message += await _audio.seek(await _audio.getCurentTime()-5.0);
      }
      if(label == 'Volume down') {
          await _audio.setVolume(await _audio.getVolume()-0.1, 1.0);
          message += ""+(await _audio.getVolume()).toString();
      }
      if(label == 'Volume up') {
          await _audio.setVolume(await _audio.getVolume()+0.1, 1.0);
          message += ""+(await _audio.getVolume()).toString();
      }
    } catch (e) {
      message +=  e.toString() +'.\r\n';
    }

    setState(() {
      _message = message;
    });
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

