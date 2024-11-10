import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starter_pack_web/module/login/controller/login_controller.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:starter_pack_web/utils/app_images.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_text.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _c = Get.find<LoginController>();

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
            child: Container(
              width: 250,
              height: 150,
              alignment: Alignment.center,
              child: Image.asset(
                loadingGif,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                width: 250,
              ),
            ),
          );
        }
        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: size.height,
              child: Image.network(
                gbSigninGif,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            Positioned(
              top: 10,
              child: Image.asset(
                textImage,
                width: size.width / 2.25,
              ),
            ),
            // Positioned(
            //   top: 200,
            //   left: 40,
            //   child: Stack(
            //     children: [
            //       ElevatedButton(
            //         onPressed: () {},
            //         style: ElevatedButton.styleFrom(
            //             backgroundColor: colorElectricViolet,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10),
            //             )),
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(
            //               vertical: 16, horizontal: 16),
            //           child: AppTextNormal.labelNormal(
            //             "Let's Play The Game!",
            //             18,
            //             Colors.white,
            //             wordSpacing: 10,
            //             letterSpacing: 6,
            //           ),
            //         ),
            //       ),
            //       Shimmer.fromColors(
            //         baseColor: Colors.red,
            //         highlightColor: Colors.white,
            //         child: const SizedBox(
            //           width: 100,
            //           height: 50,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Positioned(
                bottom: 50.0,
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
                              45,
                              colorElectricViolet,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        );
      }),
    );
  }
}
