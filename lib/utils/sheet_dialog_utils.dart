import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:expireance/core/presentation/widgets/sheets.dart';

abstract class SheetDialogUtils {
  static void showAppBarSheet({
    required BuildContext context,
    required Widget child,
  }) {
    showBarModalBottomSheet(
      context: context,
      bounce: true,
      topControl: const SheetIndicator(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child,
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  static void showAppDialog({
    required BuildContext context,
    required Widget child,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => child,
    );
  }
}
