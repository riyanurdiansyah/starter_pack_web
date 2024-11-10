import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/dashboard/controller/role_controller.dart';
import 'package:starter_pack_web/module/user/model/role_m.dart';
import 'package:starter_pack_web/utils/app_data_table.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_text.dart';

class RolePage extends StatelessWidget {
  RolePage({super.key});

  final _c = Get.find<RoleController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Obx(
              () => Container(
                color: Colors.white,
                child: AppDataTable<RoleM>(
                  headers: const ["ID", "Role"],
                  datas: _c.isUsingRoles(),
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
                              child: AppTextNormal.labelW500(
                                data.id,
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                data.role,
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
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => AppDialog.dialogUser(),
        backgroundColor: Colors.blue,
        child: AppTextNormal.labelW600(
          "+",
          30,
          Colors.white,
        ),
      ),
    );
  }
}
