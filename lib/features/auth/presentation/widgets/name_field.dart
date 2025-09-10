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
      autocorrect: false,
      enableSuggestions: false,
      textCapitalization: TextCapitalization.none,
      validator: (value) {
        const blockedWords = [
          'admin',
          'fuck',
          'shit',
          'bitch',
          'putang',
          'putangina',
          'bobo',
          'tarantado',
          'gago',
          'tanga',
          'ulol',
        ];

        if (value == null || value.trim().isEmpty) {
          return 'Please enter a name to continue.';
        }

        if (!RegExp(r'^[a-zA-Z]').hasMatch(value)) {
          return 'Please start your name with a letter.';
        }

        if (value.trim().length < 3) {
          return 'Your name should be at least 3 characters.';
        }

        final nameLower = value.toLowerCase();
        if (blockedWords.any((word) => nameLower.contains(word))) {
          return 'Oops! Try something a bit more friendly.';
        }

        if (RegExp(r'[^a-zA-Z0-9_]').hasMatch(value)) {
          return 'Use only letters, numbers, or underscores.';
        }

        if (RegExp(r'[\u{1F600}-\u{1F64F}]', unicode: true).hasMatch(value)) {
          return 'Emojis are fun, but let’s keep them out of your name.';
        }

        if (RegExp(r'[_]{2,}').hasMatch(value)) {
          return 'Let’s avoid using too many underscores in a row.';
        }

        if (value.trim().length > 20) {
          return 'That’s a bit long — keep it under 20 characters.';
        }

        // TODO: 닉네임 중복 검증
        // final isDuplicate = await nicknameExistsInServer(value);
        // if (isDuplicate) return 'That name is already taken.';

        return null;
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
