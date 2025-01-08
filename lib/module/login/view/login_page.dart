import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starter_pack_web/module/login/controller/login_controller.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_images.dart';
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
                Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: size.height,
                  child: Image.asset(
                    bgVidLogin,
                    fit: isMobile ? BoxFit.fitWidth : BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
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
