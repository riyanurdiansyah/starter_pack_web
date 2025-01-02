import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  Rx<bool> isPlaySound = false.obs;
  Future playMusic() async {
    if (!isPlaySound.value) {
      await audioPlayer.play(AssetSource("music/sound.mp3"));
      isPlaySound.value = true;
    }
  }
}
