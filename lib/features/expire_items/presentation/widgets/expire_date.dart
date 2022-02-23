import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:auto_route/auto_route.dart';

import '../../../../core/presentation/widgets/sheets.dart';

class ExpireDate extends StatelessWidget {
  final DateTime? date;
  final ValueChanged<DateTime> pickDate;

  const ExpireDate({
    Key? key,
    required this.date,
    required this.pickDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _PickerButton(
          onPressed: () {
            showBarModalBottomSheet(
              context: context,
              bounce: true,
              expand: false,
              topControl: const SheetIndicator(),
              backgroundColor: Theme.of(context).canvasColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
              ),
              builder: (ctx) => Container(
                height: 456,
                padding: const EdgeInsets.all(16),
                child: SfDateRangePicker(
                  backgroundColor: Theme.of(context).canvasColor,
                  headerHeight: 40,
                  headerStyle: DateRangePickerHeaderStyle(
                    textStyle: Theme.of(context).textTheme.headline6,
                  ),
                  minDate: DateTime.now(),
                  initialSelectedDate: date ?? DateTime.now(),
                  yearCellStyle: DateRangePickerYearCellStyle(
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: AppColor.dark),
                    disabledDatesTextStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: AppColor.gray),
                    todayTextStyle:
                        Theme.of(context).textTheme.bodyText2?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                    todayCellDecoration: BoxDecoration(
                      color: AppColor.light,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: AppColor.dark),
                    disabledDatesTextStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: AppColor.gray),
                    todayTextStyle:
                        Theme.of(context).textTheme.bodyText2?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                    todayCellDecoration: BoxDecoration(
                      color: AppColor.light,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  showNavigationArrow: true,
                  selectionColor: Theme.of(context).primaryColor,
                  selectionShape: DateRangePickerSelectionShape.rectangle,
                  selectionRadius: 16,
                  selectionTextStyle:
                      Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: Theme.of(context).canvasColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                  selectionMode: DateRangePickerSelectionMode.single,
                  showActionButtons: true,
                  confirmText: "Pick",
                  cancelText: "Cancel",
                  onCancel: () {
                    context.router.pop();
                  },
                  onSubmit: (obj) {
                    pickDate(obj as DateTime);

                    context.router.pop();
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 4),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Expire Date:",
              style: TextStyle(
                color: AppColor.gray,
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              date == null ? "Not Selected" : DateFormat.yMMMd().format(date!),
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: AppColor.dark,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PickerButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _PickerButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      minWidth: 0,
      height: 0,
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(8),
      shape: const CircleBorder(),
      child: SvgPicture.asset(
        "assets/icons/date.svg",
        width: 16,
        height: 16,
        color: AppColor.white,
      ),
      onPressed: onPressed,
    );
  }
}
