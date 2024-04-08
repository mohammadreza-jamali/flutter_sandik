
import 'package:event_bus/event_bus.dart';
import 'package:flutter_sandik/core/application/shared_preference_manager.dart';
import 'package:flutter_sandik/core/constants/app_style.dart';
import 'package:flutter_sandik/core/constants/core_enum.dart';
import 'package:flutter_sandik/core/entities/dtos/theme_dto.dart';
import 'package:flutter_sandik/locator.dart';

class ThemeManager {
  late SharedPreferenceManager _preference;
  late EventBus _eventBus;
  ThemeManager() {
    _preference = SharedPreferenceManager.getInstanse();
    _eventBus = locator<EventBus>();
  }

  void createTheme() {
    _eventBus.fire(getTheme());
  }

  ThemeDto getTheme() {
    var theme = ThemeDto();
    if (_preference.getThemeName() == ThemeNames.Dark.toString()) {
      theme.theme = AppStyle.darkTheme;
      theme.themeName = ThemeNames.Dark;
    } else {
      theme.theme = AppStyle.lightTheme;
      theme.themeName = ThemeNames.Light;
    }
    
    return theme;
  }
}
