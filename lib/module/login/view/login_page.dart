import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/login/controller/login_controller.dart';
import 'package:starter_pack_web/utils/app_images.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_decoration.dart';
import '../../../utils/app_text.dart';
import '../../../utils/app_validator.dart';

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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpinKitRotatingCircle(
                color: colorPointRank,
                size: 50.0,
              ),
              const SizedBox(
                height: 25,
              ),
              AppTextNormal.labelBold(
                "Loading...",
                14,
                Colors.grey.shade600,
              ),
            ],
          );
        }
        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: size.height,
              child: Image.asset(
                bgSigninImage,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            Center(
              child: Container(
                width: size.width / 3,
                height: size.height / 1.5,
                color: Colors.white.withOpacity(0.6),
                padding:
                    const EdgeInsets.symmetric(vertical: 35, horizontal: 50),
                child: Form(
                  key: _c.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(textImage),
                      const SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _c.tcUsername,
                        textInputAction: TextInputAction.next,
                        decoration: textFieldAuthDecoration(
                            fontSize: 14, hintText: "username", radius: 4),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) => AppValidator.requiredField(val!,
                            errorMsg: "Username tidak boleh kosong"),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _c.tcPassword,
                        textInputAction: TextInputAction.go,
                        onEditingComplete: () => _c.onLogin(),
                        decoration: textFieldAuthDecoration(
                            fontSize: 14, hintText: "Password", radius: 4),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) => AppValidator.requiredField(val!,
                            errorMsg: "Password tidak boleh kosong"),
                      ),
                      Obx(() {
                        if (_c.errorMessage.isEmpty) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: AppTextNormal.labelNormal(
                              _c.errorMessage.value, 14, Colors.red),
                        );
                      }),
                      const SizedBox(
                        height: 35,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)))),
                            backgroundColor:
                                WidgetStateProperty.all(colorPointRank),
                          ),
                          onPressed: () => _c.onLogin(),
                          child: AppTextNormal.labelBold(
                            "SIGN IN",
                            18,
                            Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
