import 'package:flutter/material.dart';

Color getColorForWilayah(String wilayah) {
  switch (wilayah) {
    case 'Aceh':
      return Colors.green;
    case 'Bali':
      return Colors.yellow;
    case 'Banten':
      return Colors.blueAccent;
    case 'Bengkulu':
      return Colors.purple;
    case 'Yogyakarta':
      return Colors.teal;
    case 'JakartaRaya':
      return Colors.cyan;
    case 'Gorontalo':
      return Colors.lime;
    case 'Jambi':
      return Colors.indigo;
    case 'JawaBarat':
      return Colors.orange; // Merah dihindari
    case 'JawaTengah':
      return Colors.amber;
    case 'JawaTimur':
      return Colors.deepOrange;
    case 'KalimantanBarat':
      return Colors.brown;
    case 'KalimantanSelatan':
      return Colors.greenAccent;
    case 'KalimantanTengah':
      return Colors.lightGreen;
    case 'KalimantanTimur':
      return Colors.cyanAccent;
    case 'KalimantanUtara':
      return Colors.orangeAccent; // Tambahan
    case 'BangkaBelitung':
      return Colors.pink; // Tambahan
    case 'KepulauanRiau':
      return Colors.lightBlue; // Tambahan
    case 'Maluku':
      return Colors.deepPurple;
    case 'MalukuUtara':
      return Colors.tealAccent;
    case 'NusaTenggaraBarat':
      return Colors.orangeAccent;
    case 'NusaTenggaraTimur':
      return Colors.redAccent; // Merah dihindari
    case 'Riau':
      return Colors.green[700]!;
    case 'SumateraBarat':
      return Colors.purpleAccent;
    case 'SumateraSelatan':
      return Colors.yellowAccent;
    case 'SumateraUtara':
      return Colors.orange[700]!;
    case 'SulawesiBarat':
      return Colors.green[300]!;
    case 'SulawesiSelatan':
      return Colors.blueGrey;
    case 'SulawesiTengah':
      return Colors.cyan[700]!;
    case 'SulawesiTenggara':
      return Colors.lime[700]!;
    case 'SulawesiUtara':
      return Colors.lightGreenAccent; // Tambahan
    case 'Lampung':
      return Colors.amberAccent;
    case 'Papua':
      return Colors.red[300]!;
    case 'PapuaBarat':
      return Colors.pinkAccent;
    default:
      return Colors.blue; // Default color jika tidak ada kecocokan
  }
}
