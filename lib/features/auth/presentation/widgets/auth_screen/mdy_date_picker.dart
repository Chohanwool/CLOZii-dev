import 'package:clozii/core/theme/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PhilippinesDateField extends StatefulWidget {
  const PhilippinesDateField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.label = 'Date of Birth',
    this.hintText = 'MM/DD/YYYY',
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<DateTime?>? onChanged;
  final String label;
  final String hintText;

  @override
  State<PhilippinesDateField> createState() => _PhilippinesDateFieldState();
}

class _PhilippinesDateFieldState extends State<PhilippinesDateField> {
  DateTime? _selectedDate;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('en', 'US'), // MM/DD/YYYY 형식 강제
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: context.colors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
              // 달력 배경을 완전히 흰색으로 설정
              surfaceContainerHighest: Colors.white,
              surfaceContainerHigh: Colors.white,
              surfaceContainer: Colors.white,
              surfaceContainerLow: Colors.white,
              surfaceContainerLowest: Colors.white,
              surfaceTint: Colors.transparent,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // MM/DD/YYYY 형식으로 텍스트 설정
        widget.controller.text = DateFormat('MM/dd/yyyy').format(picked);
      });

      widget.onChanged?.call(picked);
    }
  }

  void _clearDate() {
    setState(() {
      _selectedDate = null;
      widget.controller.clear();
    });
    widget.onChanged?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      readOnly: true, // 직접 입력 방지
      onTap: _selectDate,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your birthdate.';
        }

        try {
          // parseStrict()를 사용하면 02/30/2024 같은 잘못된 날짜도 잡을 수 있음.
          DateFormat('MM/dd/yyyy').parseStrict(value);
        } catch (e) {
          return 'Hmm... That doesn’t look like a valid date (MM/DD/YYYY).';
        }

        final parsedDate = DateFormat('MM/dd/yyyy').parseStrict(value);
        final today = DateTime.now();
        final age =
            today.year -
            parsedDate.year -
            // (현재 월 < 생월) 이거나 (현재 월 = 생월 이지만 아직 생일 전) -> 생일이 안 지난 년도 차감 (-1)
            ((today.month < parsedDate.month ||
                    (today.month == parsedDate.month &&
                        today.day < parsedDate.day))
                ? 1
                : 0);

        if (parsedDate.isAfter(today)) {
          return 'Birthdate can\'t be in the future.';
        }
        if (age < 18) {
          return 'You must be at least 18 to join.';
        }
        if (age > 120) {
          return 'That doesn’t seem right. Please check your birth year.';
        }

        return null;
      },
      decoration: InputDecoration(
        isDense: true,

        label: Text(widget.label, style: context.textTheme.labelLarge),
        floatingLabelBehavior: FloatingLabelBehavior.always,

        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),

        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                style: IconButton.styleFrom(overlayColor: Colors.transparent),
                onPressed: _clearDate,
                icon: const Icon(Icons.cancel, color: Colors.grey),
              )
            : const Icon(Icons.calendar_today, color: Colors.grey),

        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
      ),
    );
  }
}
