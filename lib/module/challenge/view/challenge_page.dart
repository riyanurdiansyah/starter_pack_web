import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_images.dart';

import '../../play/view/play_page.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  List<GlobalKey<FlipCardState>> cardKeys =
      List.generate(4, (index) => GlobalKey<FlipCardState>());
  List<bool> isHoveredList = List.generate(4, (index) => false);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade200,
        leadingWidth: 115,
        leading: InkWell(
          onTap: () => context.pop(),
          child: ClipPath(
            clipper: TrapezoidClipper(),
            child: Container(
              alignment: Alignment.center,
              color: Colors.black26,
              height: 45,
              child: Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Image.asset(
                  backImage,
                  width: 50,
                ),
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Row(
              children: [
                Image.asset(
                  dollarImage,
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
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: List.generate(
                4,
                (index) => Expanded(
                  child: ClipPath(
                    clipper: MyClipper(),
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          isHoveredList[index] = true;
                        });

                        if (cardKeys[index].currentState?.isFront == true) {
                          cardKeys[index].currentState?.toggleCard();
                        }
                      },
                      onExit: (_) {
                        setState(() {
                          isHoveredList[index] = false;
                        });

                        if (cardKeys[index].currentState?.isFront == false) {
                          cardKeys[index].currentState?.toggleCard();
                        }
                      },
                      child: FlipCard(
                        key: cardKeys[index],
                        flipOnTouch: false,
                        front: Stack(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: size.height / 1.5,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                image: DecorationImage(
                                  image: AssetImage(
                                      "$baseImage/${(index + 1)}.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            // Positioned(
                            //   top: 0,
                            //   bottom: 0,
                            //   left: 0,
                            //   right: 0,
                            //   child: Image.asset(
                            //     "assets/5.png",
                            //     width: 50,
                            //   ),
                            // ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Text(
                                  "Week of 1",
                                  style: GoogleFonts.exo2(
                                    fontSize: 26,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 8,
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(
                                            2.0, 2.0), // Posisi bayangan (x, y)
                                        blurRadius:
                                            3.0, // Tingkat blur bayangan
                                        color: Colors.white.withOpacity(
                                            0.5), // Warna bayangan dengan opacity
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        back: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: size.height / 1.5,
                          color: Colors.amber.shade200,
                          child: Center(
                            child: Text(
                              "Back of Card ${index + 1}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double cutSizeShort = 20.0; // Ukuran potongan diagonal standar
    double cutSizeLong =
        45.0; // Ukuran potongan diagonal untuk kiri atas dan kiri bawah

    Path path = Path();

    // Mulai dari titik di sebelah kiri atas setelah potongan diagonal (lebih panjang)
    path.moveTo(cutSizeLong, 0);

    // Garis lurus ke kanan atas dengan potongan sudut kanan atas
    path.lineTo(size.width - cutSizeShort, 0);
    path.lineTo(size.width, cutSizeShort);

    // Garis lurus ke bawah kanan dengan potongan sudut kanan bawah
    path.lineTo(size.width, size.height - cutSizeLong);
    path.lineTo(size.width - cutSizeLong, size.height);

    // Garis lurus ke kiri bawah dengan potongan sudut kiri bawah (lebih panjang)
    path.lineTo(cutSizeShort, size.height);
    path.lineTo(0, size.height - cutSizeShort);

    // Garis lurus ke kiri atas dengan potongan sudut kiri atas (lebih panjang)
    path.lineTo(0, cutSizeLong);
    path.lineTo(cutSizeLong, 0);

    path.close(); // Menutup path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
