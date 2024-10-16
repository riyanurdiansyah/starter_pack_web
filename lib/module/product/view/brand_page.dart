import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/product/controller/product_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_decoration.dart';
import '../../../utils/app_text.dart';
import '../../../utils/app_validator.dart';

class BrandPage extends StatelessWidget {
  BrandPage({super.key});

  final _c = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AppTextNormal.labelBold(
              "Brand",
              18,
              colorPrimaryDark,
            ),
          ),
          14.ph,
          TextFormField(
            // controller: _authC.tcUsername,
            textInputAction: TextInputAction.next,
            decoration: textFieldAuthDecoration(
                fontSize: 14, hintText: "Name of your brand", radius: 4),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) => AppValidator.requiredField(val!,
                errorMsg: "Brand tidak boleh kosong"),
          ),
          20.ph,
          Align(
            alignment: Alignment.centerLeft,
            child: AppTextNormal.labelBold(
              "Iklan",
              18,
              colorPrimaryDark,
            ),
          ),
          14.ph,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            margin: const EdgeInsets.only(bottom: 14),
            width: double.infinity,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTextNormal.labelW600(
                  "Fee \$100",
                  20,
                  colorPrimaryDark,
                ),
                Obx(
                  () => CupertinoSwitch(
                    value: _c.isUseIklan.value,
                    onChanged: _c.onChangeIklan,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
