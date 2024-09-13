/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/backgrounds
  $AssetsImagesBackgroundsGen get backgrounds =>
      const $AssetsImagesBackgroundsGen();

  /// File path: assets/images/empty_note.png
  AssetGenImage get emptyNote =>
      const AssetGenImage('assets/images/empty_note.png');

  /// File path: assets/images/empty_notebook.png
  AssetGenImage get emptyNotebook =>
      const AssetGenImage('assets/images/empty_notebook.png');

  /// File path: assets/images/empty_page.png
  AssetGenImage get emptyPage =>
      const AssetGenImage('assets/images/empty_page.png');

  /// Directory path: assets/images/icons
  $AssetsImagesIconsGen get icons => const $AssetsImagesIconsGen();

  /// File path: assets/images/splash.jpg
  AssetGenImage get splash => const AssetGenImage('assets/images/splash.jpg');

  /// List of all assets
  List<AssetGenImage> get values =>
      [emptyNote, emptyNotebook, emptyPage, splash];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/en.json
  String get en => 'assets/translations/en.json';

  /// File path: assets/translations/tr.json
  String get tr => 'assets/translations/tr.json';

  /// List of all assets
  List<String> get values => [en, tr];
}

class $AssetsImagesBackgroundsGen {
  const $AssetsImagesBackgroundsGen();

  /// File path: assets/images/backgrounds/darkCardBackground.jpg
  AssetGenImage get darkCardBackground =>
      const AssetGenImage('assets/images/backgrounds/darkCardBackground.jpg');

  /// File path: assets/images/backgrounds/lightCardBackground.jpg
  AssetGenImage get lightCardBackground =>
      const AssetGenImage('assets/images/backgrounds/lightCardBackground.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [darkCardBackground, lightCardBackground];
}

class $AssetsImagesIconsGen {
  const $AssetsImagesIconsGen();

  /// File path: assets/images/icons/chart.svg
  SvgGenImage get chart => const SvgGenImage('assets/images/icons/chart.svg');

  /// File path: assets/images/icons/chest.svg
  SvgGenImage get chest => const SvgGenImage('assets/images/icons/chest.svg');

  /// File path: assets/images/icons/chest2.svg
  SvgGenImage get chest2 => const SvgGenImage('assets/images/icons/chest2.svg');

  /// File path: assets/images/icons/google_icon.svg
  SvgGenImage get googleIcon =>
      const SvgGenImage('assets/images/icons/google_icon.svg');

  /// File path: assets/images/icons/money.svg
  SvgGenImage get money => const SvgGenImage('assets/images/icons/money.svg');

  /// File path: assets/images/icons/money2.svg
  SvgGenImage get money2 => const SvgGenImage('assets/images/icons/money2.svg');

  /// File path: assets/images/icons/piggy-bank.png
  AssetGenImage get piggyBank =>
      const AssetGenImage('assets/images/icons/piggy-bank.png');

  /// File path: assets/images/icons/question.svg
  SvgGenImage get question =>
      const SvgGenImage('assets/images/icons/question.svg');

  /// File path: assets/images/icons/user.svg
  SvgGenImage get user => const SvgGenImage('assets/images/icons/user.svg');

  /// List of all assets
  List<dynamic> get values => [
        chart,
        chest,
        chest2,
        googleIcon,
        money,
        money2,
        piggyBank,
        question,
        user
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final BytesLoader loader;
    if (_isVecFormat) {
      loader = AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
