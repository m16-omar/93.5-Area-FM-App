import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void setOpen(bool isOpen) => state = isOpen;
}

final isDrawerOpenProvider = NotifierProvider<DrawerNotifier, bool>(DrawerNotifier.new);
