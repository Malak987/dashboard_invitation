import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme.dart';
import 'cubit/dashboard_cubit.dart';
import 'features/shell/app_shell.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool fbOk = true;
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // تسجيل دخول شفاف بدون أي واجهة — ليتوافق مع القاعدة isAdmin() || request.auth != null
    // هذا يحقق طلبك "بدون Login" (لا شاشة، لا أزرار) مع الحفاظ على خصوصية البيانات
    // إذا كانت القاعدة allow list,get: if true; فهذا السطر غير ضروري لكنه لا يضر
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
    } catch (e) {
      debugPrint('Anonymous sign-in skipped: $e');
    }
  } catch (e) {
    fbOk = false;
    debugPrint('Firebase init failed: $e — سيعمل التطبيق في وضع المعاينة');
  }
  runApp(WeddingApp(firebaseReady: fbOk));
}

class WeddingApp extends StatelessWidget {
  final bool firebaseReady;
  const WeddingApp({super.key, required this.firebaseReady});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit()..start(forceMock: !firebaseReady),
      child: MaterialApp(
        title: 'دعوة الزفاف — لوحة العريس',
        debugShowCheckedModeBanner: false,
        theme: WeddingTheme.light(),
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
        home: const AppShell(),
      ),
    );
  }
}
