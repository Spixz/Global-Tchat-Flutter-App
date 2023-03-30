import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_widgets/alert_dialogs.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/localization/string_hardcoded.dart';

extension AsyncValueUi on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      showExceptionAlertDialog(
          context: context, title: "Erreur".hardcoded, exception: error);
    }
  }
}
