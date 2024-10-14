import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class PlayController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();

  Rx<bool> isPlaying = false.obs;

  @override
  void onInit() async {
    super.onInit();
    Future.delayed(const Duration(seconds: 10), () {
      playMusic();
    });
  }

  Future playMusic() async {
    await audioPlayer.play(AssetSource("music/sound.mp3"));
  }

  Future playMusicCar() async {
    await audioPlayer.play(AssetSource("music/car.wav"));
  }
}
