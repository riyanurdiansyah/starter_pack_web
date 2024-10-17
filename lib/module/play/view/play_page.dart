import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/play/controller/play_controller.dart';
import 'package:starter_pack_web/utils/app_color.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_images.dart';

class PlayPage extends StatelessWidget {
  PlayPage({super.key});

  final _c = Get.find<PlayController>();

  @override
  Widget build(BuildContext context) {
    final List<String> menuItems = [
      "Challenge",
      "Leader Board",
      "Setting",
      "Product",
      "Finance"
    ];
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
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
          ClipPath(
            clipper: TrapezoidClipper(),
            child: Container(
              width: size.width / 2,
              height: size.height,
              color: Colors.black.withOpacity(0.8),
              child: Column(
                children: [
                  25.ph,
                  Image.asset(
                    textImage,
                    width: size.width / 2.5,
                  ),
                  100.ph,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    width: size.width / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: menuItems
                          .map((item) => HoverTextItem(text: item))
                          .toList(),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 18),
                    child: Row(
                      children: [
                        Image.asset(
                          cImage,
                          width: 20,
                          color: Colors.white,
                        ),
                        10.pw,
                        const AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 300),
                          style: TextStyle(
                            fontFamily: 'Race',
                            letterSpacing: 10,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                          child: Text("Tim Rakor MFG"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

  const HoverTextItem({super.key, required this.text});

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
      onHover: (_) {
        _c.playMusicCar();
        if (!_c.isPlaying.value) {
          _c.playMusic();
        }
      },
      onEnter: (_) {
        setState(() {
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
          if (widget.text == "Challenge") {
            context.goNamed(AppRouteName.challenge);
          }
          if (widget.text == "Leader Board") {
            context.goNamed(AppRouteName.board);
          }

          if (widget.text == "Setting") {
            context.goNamed("/${AppRouteName.setting}");
          }
          if (widget.text == "Product") {
            context.goNamed(AppRouteName.product);
          }
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
