import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starter_pack_web/module/login/controller/login_controller.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:starter_pack_web/utils/app_images.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _c = Get.find<LoginController>();

  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.asset(
        bgVidLogin) // Video dari folder assets
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {}); // Memastikan widget dirender ulang setelah video siap
        videoPlayerController.play();
      });
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Obx(() {
        if (_c.isLoading.value) {
          return Container(
            color: Colors.black,
            width: double.infinity,
            height: size.height,
            child: Center(
              child: Image.asset(
                loadingGif,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                width: 250,
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            return Stack(
              children: [
                if (videoPlayerController.value.isInitialized)
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover, // Mengatur video agar menutupi layar
                      child: SizedBox(
                        width: videoPlayerController.value.size.width,
                        height: videoPlayerController.value.size.height,
                        child: VideoPlayer(videoPlayerController),
                      ),
                    ),
                  ),

                // Container(
                //   color: Colors.black,
                //   width: double.infinity,
                //   height: size.height,
                //   child: CachedNetworkImage(
                //     imageUrl: gbSigninGif,
                //     fit: isMobile ? BoxFit.fitWidth : BoxFit.cover,
                //     filterQuality: FilterQuality.high,
                //   ),
                // ),
                Positioned(
                  top: isMobile ? 40 : 0,
                  left: isMobile ? 10 : null,
                  right: isMobile ? 10 : null,
                  child: SizedBox(
                    height: 200,
                    child: Image.asset(
                      textImage,
                      width: isMobile ? size.width * 0.8 : size.width / 2.25,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Positioned(
                  bottom: isMobile ? 30.0 : 50.0,
                  left: 0.0,
                  right: 0.0,
                  child: Center(
                    child: Opacity(
                      opacity: 0.8,
                      child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: colorElectricViolet,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            InkWell(
                              onTap: () => AppDialog.dialogSignin(),
                              child: AppTextNormal.labelNormal(
                                "Let's Play The Game!",
                                isMobile ? 30 : 45,
                                colorElectricViolet,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
