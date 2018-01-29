package net.umiuni2d.umiuni2daudio;

import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * Umiuni2dAudioPlugin
 */
public class Umiuni2dAudioPlugin implements MethodCallHandler {
  private final Registrar mRegistrar;
  private MediaPlayer mMediaPlayer;
  private float mVolume = 0.0f;

  Umiuni2dAudioPlugin(Registrar registrar){
    mRegistrar = registrar;
    AudioManager am = (AudioManager)registrar.activity().getSystemService(Context.AUDIO_SERVICE);
    int volumeLevel = am.getStreamVolume(AudioManager.STREAM_MUSIC);
    int maxVolume = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
    mVolume = volumeLevel/maxVolume;
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "umiuni2d_audio");
    channel.setMethodCallHandler(new Umiuni2dAudioPlugin(registrar));

  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    String methodName = call.method;
    if(methodName == "" || methodName == null) {
      return;
    }

    if (call.method.equals("getPath")) {
      result.success(mRegistrar.context().getFilesDir().getPath());
    } else {
      if(mMediaPlayer == null) {
        mMediaPlayer = new MediaPlayer();
        mMediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
      }
      if(call.method.equals("load")) {
        List args = (List)call.arguments;
        try {
          mMediaPlayer.setDataSource((String) args.get(0));
          mMediaPlayer.prepare();
          result.success("{\"status\":\"passed\"}");
        } catch(Exception e) {
          result.success("{\"status\":\"failed\"}");
        }
        return;
      } else if(call.method.equals("play")) {
        try {
          mMediaPlayer.start();
          result.success("{\"status\":\"passed\"}");
        } catch(Exception e) {
          result.success("{\"status\":\"failed\"}");
        }
        return;
      } else if(call.method.equals("pause")) {
        try {
          mMediaPlayer.pause();
          result.success("{\"status\":\"passed\"}");
        } catch(Exception e) {
          result.success("{\"status\":\"failed\"}");
        }
        return;
      } else if(call.method.equals("stop")) {
        try {
          mMediaPlayer.stop();
          result.success("{\"status\":\"passed\"}");
        } catch(Exception e) {
          result.success("{\"status\":\"failed\"}");
        }
        return;
      } else if(call.method.equals("seek")) {
        List args = (List)call.arguments;
        try {
          double v = ((Number)args.get(0)).doubleValue();
          v = v*1000;
          mMediaPlayer.seekTo((int)v);
          result.success("{\"status\":\"passed\"}");
        } catch(Exception e) {
          result.success("{\"status\":\"failed\"}");
        }
        return;
      } else if(call.method.equals("getCurentTime")) {
        try {
          int v = mMediaPlayer.getCurrentPosition();
          result.success(((double)v)/1000.0);
        } catch(Exception e) {
          result.success("{\"status\":\"failed\"}");
        }
        return;
      } else if(call.method.equals("setVolume")) {
        List args = (List)call.arguments;
        try {
          float volume = ((Number)args.get(0)).floatValue();
          mVolume = volume;
          mMediaPlayer.setVolume(mVolume, mVolume);
          result.success(((double)volume)/1000.0);
        } catch(Exception e) {
          result.success("{\"status\":\"failed\"}");
        }
        return;
      } else if(call.method.equals("getVolume")) {
        try {
          result.success(mVolume);
        } catch(Exception e) {
          result.success("{\"status\":\"failed\"}");
        }
        return;
      }



      result.notImplemented();
    }
  }
}
