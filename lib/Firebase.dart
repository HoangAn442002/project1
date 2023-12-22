import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:web_dat_hang/main.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Tiếp tục chạy ứng dụng Flutter của bạn sau khi Firebase đã được khởi tạo.
  runApp(MyApp());
}
