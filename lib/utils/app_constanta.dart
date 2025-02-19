import 'package:starter_pack_web/module/challenge/model/challenge_m.dart';
import 'package:starter_pack_web/module/news/model/news_m.dart';
import 'package:starter_pack_web/module/user/model/group_m.dart';
import 'package:starter_pack_web/module/user/model/role_m.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:starter_pack_web/utils/app_images.dart';

final userEmpty = UserM(
  id: "",
  nama: "",
  username: "",
  password: "",
  roleId: 0,
  role: "",
  kelompok: "",
  kelompokId: 0,
  page: 0,
  groupId: "",
  point: 0,
  isUsePrivillege: false,
);

final roleEmpty = RoleM(
  id: "",
  role: "",
  roleId: 0,
  page: 0,
  max: 1,
  image: "",
);

final groupEmpty = GroupM(
  alias: "",
  country: "",
  profit: 0,
  groupId: 0,
  id: "",
  image: "",
  name: "",
  point: 0,
  pointBefore: 0,
  revenue: 0,
  page: 0,
  updatedDate: DateTime.now().toIso8601String(),
);

final challengeEmpty = ChallengeM(
  route: "",
  start: "",
  isUseSpecialChallenge: false,
  end: "",
  no: 0,
  id: "",
  image: "",
  name: "",
  page: 0,
  type: "",
  time: 0,
  maxQuestion: 0,
  maxPoint: 0,
  isRevenue: false,
  isSpecialChallenge: false,
);

final imageBOD = [
  andyImg,
  putuImg,
  totokImg,
  desyImg,
];

final newsEmpty = NewsM(
    isForAll: false,
    id: "",
    content: "",
    title: "",
    image: "",
    date: "",
    page: 0,
    users: []);

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

// List<GroupM> groupList = [
//   GroupM(
//     alias: "Nissan",
//     country: "JP", // Jepang
//     groupId: 1,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 1",
//     point: 100,
//     pointBefore: 50,
//     page: 0,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Audi",
//     country: "DE", // Jerman
//     groupId: 2,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 2",
//     point: 110,
//     pointBefore: 55,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Porsche",
//     country: "DE", // Jerman
//     groupId: 3,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 3",
//     point: 120,
//     pointBefore: 60,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Mercedes-AMG",
//     country: "DE", // Jerman
//     groupId: 4,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 4",
//     point: 130,
//     pointBefore: 65,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Lamborghini",
//     country: "IT", // Italia
//     groupId: 5,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 5",
//     point: 140,
//     pointBefore: 70,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Ferrari",
//     country: "IT", // Italia
//     groupId: 6,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 6",
//     point: 150,
//     pointBefore: 75,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Aston Martin",
//     country: "GB", // Inggris
//     groupId: 7,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 7",
//     point: 160,
//     pointBefore: 80,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "McLaren",
//     country: "GB", // Inggris
//     groupId: 8,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 8",
//     point: 170,
//     pointBefore: 85,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Jaguar",
//     country: "GB", // Inggris
//     groupId: 9,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 9",
//     point: 180,
//     pointBefore: 90,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Bentley",
//     country: "GB", // Inggris
//     groupId: 10,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 10",
//     point: 190,
//     pointBefore: 95,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Red Bull Racing",
//     country: "AT", // Austria
//     groupId: 11,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 11",
//     point: 200,
//     pointBefore: 100,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Alfa Romeo",
//     country: "IT", // Italia
//     groupId: 12,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 12",
//     point: 210,
//     pointBefore: 105,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Williams Racing",
//     country: "GB", // Inggris
//     groupId: 13,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 13",
//     point: 220,
//     pointBefore: 110,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Haas F1 Team",
//     country: "US", // Amerika Serikat
//     groupId: 14,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 14",
//     point: 230,
//     pointBefore: 115,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Alpine",
//     country: "FR", // Prancis
//     groupId: 15,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 15",
//     point: 240,
//     pointBefore: 120,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Scuderia Ferrari",
//     country: "IT", // Italia
//     groupId: 16,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 16",
//     point: 250,
//     pointBefore: 125,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Toyota",
//     country: "JP", // Jepang
//     groupId: 17,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 17",
//     point: 260,
//     pointBefore: 130,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Lotus",
//     country: "GB", // Inggris
//     groupId: 18,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 18",
//     point: 270,
//     pointBefore: 135,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
//   GroupM(
//     alias: "Ford",
//     country: "US", // Amerika Serikat
//     groupId: 19,
//     id: const Uuid().v4(),
//     image: "",
//     name: "Kelompok 19",
//     point: 280,
//     pointBefore: 140,
//     updatedDate: DateTime.now().toIso8601String(),
//   ),
// ];
