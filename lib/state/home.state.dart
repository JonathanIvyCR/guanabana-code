import 'dart:async';
// ignore: implementation_imports
import 'package:audioplayers/src/audioplayer.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../zelpers/gi.dart';
import 'progress.state.dart';

enum MyPlayerStatus {
  playing,
  stopped,
}

class HomeState with ChangeNotifier {
  late Timer timerMinute;
  late AudioPlayer playerLyrics;
  late AudioPlayer playerSong;
  bool _futuresLoaded = false;
  bool get futuresLoaded => _futuresLoaded;
  void setFuturesLoaded(bool value) async {
    _futuresLoaded = value;
    // notifyListeners();
  }

  MyPlayerStatus _myPlayerStatus = MyPlayerStatus.stopped;
  MyPlayerStatus get myPlayerStatus => _myPlayerStatus;
  void setMyPlayerStatus(MyPlayerStatus value) {
    _myPlayerStatus = value;
    notifyListeners();
  }

  bool _showGameStack = true;
  bool get showGameStack => _showGameStack;
  void flipShowGameStack() {
    _showGameStack = !_showGameStack;
    notifyListeners();
  }

  double _volume = .2;
  double get volume => _volume;
  void setVolume(double value) {
    _volume = value;
    notifyListeners();
  }

  bool _playMusic = true;
  bool get playMusic => _playMusic;
  void setPlayMusic(bool value) {
    _playMusic = value;
    // notifyListeners();
  }

  Size _screenSize = Size.zero;
  Size get screenSize => _screenSize;
  void setScreenSize(Size value) {
    _screenSize = value;
    // notifyListeners();
  }

  bool _startGameClips = false;
  bool get startGameClips => _startGameClips;
  void setStartGameClips(bool value) {
    _startGameClips = value;
    notifyListeners();
  }

  bool _showCountdown = false;
  bool get showCountdown => _showCountdown;
  void setShowCountdown(bool value) {
    _showCountdown = value;
    notifyListeners();
  }

  bool _showNewGame = true;
  bool get showNewGame => _showNewGame;
  void setShowNewGame(bool value) {
    _showNewGame = value;
    notifyListeners();
  }

  bool _showGameStats = false;
  bool get showGameStats => _showGameStats;
  void setShowGameStats(bool value) {
    _showGameStats = value;
    notifyListeners();
  }

  void _setFutures() {
    if (!gi<HomeState>().futuresLoaded) {
      gi<HomeState>().setFuturesLoaded(true);

      List<int> _times = [
        2200,
        4800,
        14500,
        17400,
        19800,
        29400,
        32400,
        34800,
        45300,
        48050,
        50400,
        59100,
      ];

      for (final int i in _times) {
        // if (i > 4800) {
        Future.delayed(Duration(milliseconds: i)).then((value) async {
          if (gi<HomeState>().playMusic &&
              !gi<ProgressState>().sayingGuanabana) {
            gi<ProgressState>().setSayingGuanabana(true);
          }
        });
        // }
      }

      gi<HomeState>().timerMinute =
          Timer.periodic(const Duration(minutes: 1), (timer) async {
        for (final int i in _times) {
          Future.delayed(Duration(milliseconds: i)).then((value) async {
            if (gi<HomeState>().playMusic &&
                !gi<ProgressState>().sayingGuanabana &&
                gi<HomeState>().futuresLoaded) {
              gi<ProgressState>().setSayingGuanabana(true);
            }
          });
        }
      });
    }
  }

  stopMusic() async {
    playerLyrics.stop();
    playerSong.stop();
    setMyPlayerStatus(MyPlayerStatus.stopped);
    timerMinute.cancel();
    setFuturesLoaded(false);

    gi<HomeState>().setPlayMusic(false);
  }

  startMusic() async {
    if (_myPlayerStatus == MyPlayerStatus.stopped) {
      setPlayMusic(true);
      _setFutures();
      playerLyrics = await FlameAudio.loop('guanabana01.mp3', volume: _volume);
      playerSong = await FlameAudio.loop('mahna-mahna.mp3', volume: _volume);
      // await gi<PuzzleState>().bgmAudio.setAsset(localPath);
      // await gi<PuzzleState>().bgmAudio.setLoopMode(LoopMode.one);
      // await gi<PuzzleState>().bgmAudio.setVolume(gi<HomeState>().volume);

      // await gi<PuzzleState>().bgmAudio.play();
      setMyPlayerStatus(MyPlayerStatus.playing);
    }
  }
}
