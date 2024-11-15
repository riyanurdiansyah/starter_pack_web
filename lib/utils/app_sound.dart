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
}
