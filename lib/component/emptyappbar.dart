import 'package:workload_meter/importer.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmptyAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light, // for iOS
        statusBarIconBrightness: Brightness.dark, // for Android
      ),
    );
    return Container();
  }

  @override
  Size get preferredSize => const Size(0.0, 0.0);
}
