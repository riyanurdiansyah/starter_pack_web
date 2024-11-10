import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/dashboard/controller/group_controller.dart';
import 'package:starter_pack_web/module/user/model/group_m.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_data_table.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_text.dart';

class GroupPage extends StatelessWidget {
  GroupPage({super.key});

  final _c = Get.find<GroupController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Obx(() {
                return Container(
                  color: Colors.white,
                  child: AppDataTable<GroupM>(
                    headers: const ["Icon", "Name", "As", "Country", "Point"],
                    datas: _c.isUsingGroups(),
                    currentPage: _c.currentPage.value,
                    totalPage: _c.isTotalPage(),
                    onPageChanged: _c.onChangepage,
                    onSearched: _c.onSearched,
                    buildRow: (data) => Column(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CachedNetworkImage(
                                    imageUrl: data.image,
                                    width: 50,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: AppTextNormal.labelW500(
                                  data.name,
                                  16,
                                  colorPrimaryDark,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: AppTextNormal.labelW500(
                                  data.alias,
                                  16,
                                  colorPrimaryDark,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: AppTextNormal.labelW500(
                                  data.country,
                                  16,
                                  colorPrimaryDark,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: AppTextNormal.labelW500(
                                  "\$${data.point}",
                                  16,
                                  colorPrimaryDark,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 26,
                                      height: 26,
                                      padding: const EdgeInsets.all(2.5),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: InkWell(
                                        onTap: () {},
                                        child: const Icon(
                                          Icons.edit_rounded,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    8.pw,
                                    Container(
                                      width: 26,
                                      height: 26,
                                      padding: const EdgeInsets.all(2.5),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: InkWell(
                                        onTap: () {},
                                        child: const Icon(
                                          Icons.delete_rounded,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 0.6,
                          width: double.infinity,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPointRank,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: AppTextNormal.labelBold(
              "RESET ALL",
              16,
              Colors.white,
              letterSpacing: 1.25,
            ),
          ),
          14.pw,
          FloatingActionButton.small(
            onPressed: () => AppDialog.dialogUser(),
            backgroundColor: Colors.blue,
            child: AppTextNormal.labelW600(
              "+",
              30,
              Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
