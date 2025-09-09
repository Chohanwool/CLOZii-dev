import 'package:clozii/core/theme/context_extension.dart';
import 'package:flutter/material.dart';

class NameField extends StatefulWidget {
  const NameField({
    super.key,
    required this.focusNode,
    required this.controller,
  });

  final FocusNode focusNode;
  final TextEditingController controller;

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Invalid name';
        }

        if (value.trim().length < 3) {
          return '\'Name\' must be more than 2 characters.';
        }

        if (value.trim().length > 20) {
          return 'Please enter a name less than 20 characters.';
        }
      },
      onChanged: (value) {},
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        isDense: true,

        label: Text('Name', style: context.textTheme.labelLarge),
        floatingLabelBehavior: FloatingLabelBehavior.always,

        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                style: IconButton.styleFrom(overlayColor: Colors.transparent),
                onPressed: () {
                  setState(() {
                    widget.controller.clear();
                  });
                },
                icon: Icon(Icons.cancel, color: context.colors.scrim),
              )
            : null,

        hintText: 'Enter phone holder\'s name',
        hintStyle: TextStyle(color: Colors.grey),

        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
      ),
    );
  }
}
