import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';
import 'package:flutter/material.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Switch.adaptive(
      activeColor: Theme.of(context).iconTheme.color,
      activeTrackColor: Theme.of(context).iconTheme.color,
      inactiveThumbColor: Theme.of(context).iconTheme.color,
      inactiveTrackColor: Theme.of(context).iconTheme.color,
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}
