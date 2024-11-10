import 'package:flutter/material.dart';
import 'package:starter_pack_web/utils/app_color.dart';

class ChallengeQuizPage extends StatelessWidget {
  const ChallengeQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: size.height,
            color: Colors.grey.withOpacity(0.6),
            // child: Image.asset(
            //   quizPlayImage,
            //   fit: BoxFit.cover,
            //   filterQuality: FilterQuality.high,
            // ),
          ),
          Center(
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 80, right: 20),
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 35,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      // margin: const EdgeInsets.only(top: 100),
                      width: size.width / 1.25,
                      decoration: BoxDecoration(
                        color: colorPointRank,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 80, left: 20),
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 35,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorElectricViolet,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
