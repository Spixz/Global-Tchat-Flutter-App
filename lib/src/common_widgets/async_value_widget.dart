import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({super.key, required this.value, required this.widget});
  final AsyncValue<T> value;
  final Widget Function(T) widget;

  @override
  Widget build(BuildContext context) {
    return value.when(
        data: widget,
        loading: () => const Placeholder(),
        error: (error, stack) => const Placeholder());
  }
}
