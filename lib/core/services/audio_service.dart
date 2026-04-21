import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();

  factory AudioService() {
    return _instance;
  }

  late AudioPlayer audioPlayer;

  late final AudioPlayer backgroundAudioPlayer;

  AudioService._internal();

  void stopAudio() {
    try {
      audioPlayer.stop();
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      audioPlayer.dispose();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getState() {
    return audioPlayer.state.name;
  }

  void dispose() {
    try {
      audioPlayer.dispose();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void playAudio({required src, Function? onComplete}) async {
    try {
      audioPlayer = AudioPlayer();

      audioPlayer.setVolume(1);
      audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      audioPlayer.setReleaseMode(ReleaseMode.stop);
      await audioPlayer.play(
        AssetSource(src),
      );
      if (onComplete != null) {
        audioPlayer.onPlayerComplete.listen((event) async {
          await onComplete();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
