import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starter_pack_web/utils/app_color.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../play/view/play_page.dart';
import 'tabbar_item.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorPrimary,
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        leadingWidth: 115,
        leading: InkWell(
          onTap: () => context.pop(),
          child: ClipPath(
            clipper: TrapezoidClipper(),
            child: Container(
              alignment: Alignment.center,
              color: Colors.white.withOpacity(0.4),
              height: 45,
              child: Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Image.asset(
                  "images/back.png",
                  width: 50,
                ),
              ),
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Image.asset(
                "images/dollar.png",
                width: 30,
              ),
              10.pw,
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: GoogleFonts.nanumGothicCoding(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                child: const Text("339.2"),
              ),
              16.pw,
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          // SizedBox(
          //   width: double.infinity,
          //   height: size.height,
          //   child: Image.asset(
          //     "images/bg3.jpg",
          //     fit: BoxFit.fill,
          //     filterQuality: FilterQuality.high,
          //   ),
          // ),
          Row(
            children: [
              const Expanded(
                flex: 7,
                child: SizedBox(),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.grey.shade200.withOpacity(0.4),
                  child: DefaultTabController(
                    length: 2, // Jumlah tab
                    child: Column(
                      children: [
                        PreferredSize(
                          preferredSize: const Size.fromHeight(40),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              height: 45,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  bottomRight: Radius.circular(14),
                                ),
                                color: colorPrimaryDark.withOpacity(0.2),
                              ),
                              child: const TabBar(
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: Colors.transparent,
                                indicator: BoxDecoration(
                                  color: colorGold,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    bottomRight: Radius.circular(14),
                                  ),
                                ),
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black54,
                                tabs: [
                                  TabItem(title: 'Brand'),
                                  TabItem(title: 'Komposisi'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Expanded(
                                child: TabBarView(
                                  children: [
                                    Center(
                                        child: Text(
                                            'Konten untuk Tab 1')), // Konten untuk tab 1
                                    Center(
                                        child: Text(
                                            'Konten untuk Tab 2')), // Konten untuk tab 2
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade300,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(14),
                                              bottomRight: Radius.circular(14),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 14),
                                          child: AnimatedDefaultTextStyle(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            style:
                                                GoogleFonts.nanumGothicCoding(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            child: const Text("RESET"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    16.pw,
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: colorGold,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(14),
                                              bottomRight: Radius.circular(14),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 14),
                                          child: AnimatedDefaultTextStyle(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            style:
                                                GoogleFonts.nanumGothicCoding(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            child: const Text("SAVE"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
