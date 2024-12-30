import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/play/controller/play_controller.dart';
import 'package:starter_pack_web/utils/app_color.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_images.dart';
import 'package:starter_pack_web/utils/app_sound.dart';
import 'package:starter_pack_web/utils/app_text.dart';

class PlayPage extends StatelessWidget {
  PlayPage({super.key});

  final _c = Get.find<PlayController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      // appBar: isMobile
      //     ? AppBar(
      //         title: AppTextNormal.labelBold("Home", 14, Colors.black),
      //         backgroundColor: Colors.white,
      //       )
      //     : null,
      drawer: isMobile
          ? Obx(
              () => SafeArea(
                child: Drawer(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: _c.menus
                          .map(
                            (item) => ListTile(
                              title: AppTextNormal.labelBold(
                                item.title,
                                14,
                                Colors.black,
                              ),
                              onTap: () {
                                if (item.title.toLowerCase() == "logout") {
                                  _c.logout();
                                  return;
                                }
                                context.pop();
                                context.goNamed(item.route);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            )
          : null,
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
              child: Image.asset(
                bgUImage,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            if (!isMobile)
              ClipPath(
                clipper: TrapezoidClipper(),
                child: Container(
                  alignment: Alignment.center,
                  width: size.width / 2,
                  height: size.height,
                  color: Colors.black.withOpacity(0.8),
                  child: SingleChildScrollView(
                    child: Obx(
                      () => Container(
                        margin: const EdgeInsets.only(top: 100, right: 75),
                        padding: const EdgeInsets.only(left: 55, right: 80),
                        width: size.width / 2,
                        height: size.height / 1.6,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _c.menus
                                .map(
                                  (item) => FittedBox(
                                    child: HoverTextItem(
                                      text: item.title,
                                      route: item.route,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              top: isMobile ? 50 : 25,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 80,
                ),
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  textImage,
                  width: isMobile ? size.width / 2 : size.width / 3.2,
                ),
              ),
            ),
            if (isMobile)
              Positioned(
                top: isMobile ? 50 : 25,
                right: 0,
                child: Builder(
                  builder: (context) => // Ensure Scaffold is in context
                      Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.grey.shade100,
                    ),
                    child: IconButton(
                        iconSize: 25,
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer()),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 80,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      cImage,
                      width: isMobile ? 15 : 20,
                      color: Colors.white,
                    ),
                    10.pw,
                    const Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 300),
                        style: TextStyle(
                          fontFamily: 'Race',
                          letterSpacing: 10,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                        child: Text("Tim Rakor MNF & IDC"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width / 1.5, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HoverTextItem extends StatefulWidget {
  final String text;
  final String route;

  const HoverTextItem({super.key, required this.text, required this.route});

  @override
  _HoverTextItemState createState() => _HoverTextItemState();
}

class _HoverTextItemState extends State<HoverTextItem> {
  bool isHovered = false;

  final _c = Get.find<PlayController>();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) {},
      onEnter: (_) {
        setState(() {
          AppSound.playHover();
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: InkWell(
        onTap: () {
          if (widget.text.toLowerCase() == "logout") {
            _c.logout();
            return;
          }
          context.goNamed(widget.route);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding:
              EdgeInsets.only(left: isHovered ? 10 : 0), // Transisi dari kiri
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontFamily: 'Race',
              fontSize: isHovered ? 45 : 35, // Ukuran font berubah saat hover
              height: 2.5,
              letterSpacing: 10,
              fontStyle: FontStyle.italic,
              color: isHovered ? colorPointRank : Colors.white,
            ),
            child: Text(widget.text),
          ),
        ),
      ),
    );
  }
}
