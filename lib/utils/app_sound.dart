import 'package:audioplayers/audioplayers.dart';

class AppSound {
  static playHover() async {
    final AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource("music/click.mp3"));
  }

  static playButton() async {
    final AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource("music/car.wav"));
  }

  static playTyping(bool isPlay) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (!isPlay) {
      await audioPlayer.play(AssetSource("music/typing.mp3"));
    } else {
      await audioPlayer.stop();
    }
  }
}
