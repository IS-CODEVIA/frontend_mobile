import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      
      primary: Color(0xff00CFBB), 
      surfaceTint: Color(0xff00CFBB),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb3f5ed), // Tonalidad clara para contenedores
      onPrimaryContainer: Color(0xff003832),
      
      secondary: Color(0xff1C258F),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdbe1ff), // Tonalidad clara para contenedores
      onSecondaryContainer: Color(0xff000b5e),
      
      
      tertiary: Color(0xff006b60),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9ef2e3),
      onTertiaryContainer: Color(0xff005048),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff171d1e),
      onSurfaceVariant: Color(0xff3f484a),
      outline: Color(0xff6f797a),
      outlineVariant: Color(0xffbfc8ca),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inversePrimary: Color(0xff57e0ce),
      primaryFixed: Color(0xffb3f5ed),
      onPrimaryFixed: Color(0xff00201c),
      primaryFixedDim: Color(0xff57e0ce),
      onPrimaryFixedVariant: Color(0xff005047),
      secondaryFixed: Color(0xffdbe1ff),
      onSecondaryFixed: Color(0xff00116a),
      secondaryFixedDim: Color(0xffb6c4ff),
      onSecondaryFixedVariant: Color(0xff001a90),
      tertiaryFixed: Color(0xff9ef2e3),
      onTertiaryFixed: Color(0xff00201c),
      tertiaryFixedDim: Color(0xff82d5c8),
      onTertiaryFixedVariant: Color(0xff005048),
      surfaceDim: Color(0xffd5dbdc),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f6),
      surfaceContainer: Color(0xffe9eff0),
      surfaceContainerHigh: Color(0xffe3e9ea),
      surfaceContainerHighest: Color(0xffdee3e5),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff008a7b),
      surfaceTint: Color(0xff00CFBB),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff00CFBB),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1C258F),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4a55c2),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003e37),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1e7a6e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff0c1213),
      onSurfaceVariant: Color(0xff2f3839),
      outline: Color(0xff4b5456),
      outlineVariant: Color(0xff656f70),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inversePrimary: Color(0xff57e0ce),
      primaryFixed: Color(0xff008a7b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff006c60),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4a55c2),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff303da5),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff1e7a6e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff006056),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc2c7c9),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f6),
      surfaceContainer: Color(0xffe3e9ea),
      surfaceContainerHigh: Color(0xffd8dedf),
      surfaceContainerHighest: Color(0xffcdd3d4),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff004d44),
      surfaceTint: Color(0xff00CFBB),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff008a7b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff00105e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff1C258F),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00332d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff00534a),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff252e2f),
      outlineVariant: Color(0xff414b4c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inversePrimary: Color(0xff57e0ce),
      primaryFixed: Color(0xff008a7b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff005e53),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff1C258F),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff001777),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff00534a),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003a33),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb4babb),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffecf2f3),
      surfaceContainer: Color(0xffdee3e5),
      surfaceContainerHigh: Color(0xffcfd5d6),
      surfaceContainerHighest: Color(0xffc2c7c9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      // --- COLORES EXACTOS DE FIGMA (ADAPTADOS A DARK MODE) ---
      primary: Color(0xff57e0ce),
      surfaceTint: Color(0xff57e0ce),
      onPrimary: Color(0xff003731),
      primaryContainer: Color(0xff00CFBB), 
      onPrimaryContainer: Color(0xff00201c),
      
      secondary: Color(0xffb6c4ff),
      onSecondary: Color(0xff002187),
      secondaryContainer: Color(0xff1C258F), 
      onSecondaryContainer: Color(0xffdbe1ff),
      // --------------------------------------------------------
      
      tertiary: Color(0xff82d5c8),
      onTertiary: Color(0xff003731),
      tertiaryContainer: Color(0xff005048),
      onTertiaryContainer: Color(0xff9ef2e3),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffdee3e5),
      onSurfaceVariant: Color(0xffbfc8ca),
      outline: Color(0xff899294),
      outlineVariant: Color(0xff3f484a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inversePrimary: Color(0xff006a5f),
      primaryFixed: Color(0xffb3f5ed),
      onPrimaryFixed: Color(0xff00201c),
      primaryFixedDim: Color(0xff57e0ce),
      onPrimaryFixedVariant: Color(0xff005047),
      secondaryFixed: Color(0xffdbe1ff),
      onSecondaryFixed: Color(0xff00116a),
      secondaryFixedDim: Color(0xffb6c4ff),
      onSecondaryFixedVariant: Color(0xff001a90),
      tertiaryFixed: Color(0xff9ef2e3),
      onTertiaryFixed: Color(0xff00201c),
      tertiaryFixedDim: Color(0xff82d5c8),
      onTertiaryFixedVariant: Color(0xff005048),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff343a3b),
      surfaceContainerLowest: Color(0xff090f10),
      surfaceContainerLow: Color(0xff171d1e),
      surfaceContainer: Color(0xff1b2122),
      surfaceContainerHigh: Color(0xff252b2c),
      surfaceContainerHighest: Color(0xff303637),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff5be4d2),
      surfaceTint: Color(0xff57e0ce),
      onPrimary: Color(0xff001a17),
      primaryContainer: Color(0xff00a493),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffbcc9ff),
      onSecondary: Color(0xff00105d),
      secondaryContainer: Color(0xff7f8fff),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff98ecdd),
      onTertiary: Color(0xff002b26),
      tertiaryContainer: Color(0xff4a9e92),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd4dee0),
      outline: Color(0xffaab4b5),
      outlineVariant: Color(0xff889294),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inversePrimary: Color(0xff005249),
      primaryFixed: Color(0xffb3f5ed),
      onPrimaryFixed: Color(0xff001512),
      primaryFixedDim: Color(0xff57e0ce),
      onPrimaryFixedVariant: Color(0xff003e37),
      secondaryFixed: Color(0xffdbe1ff),
      onSecondaryFixed: Color(0xff000a4c),
      secondaryFixedDim: Color(0xffb6c4ff),
      onSecondaryFixedVariant: Color(0xff1626a4),
      tertiaryFixed: Color(0xff9ef2e3),
      onTertiaryFixed: Color(0xff001511),
      tertiaryFixedDim: Color(0xff82d5c8),
      onTertiaryFixedVariant: Color(0xff003e37),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff3f4647),
      surfaceContainerLowest: Color(0xff040809),
      surfaceContainerLow: Color(0xff191f20),
      surfaceContainer: Color(0xff23292a),
      surfaceContainerHigh: Color(0xff2d3435),
      surfaceContainerHighest: Color(0xff393f40),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa9fdf0),
      surfaceTint: Color(0xff57e0ce),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff5be4d2),
      onPrimaryContainer: Color(0xff000e0c),
      secondary: Color(0xfffdfaff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbcc9ff),
      onSecondaryContainer: Color(0xff00073c),
      tertiary: Color(0xffaffff1),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff7ed1c4),
      onTertiaryContainer: Color(0xff000e0b),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe8f2f3),
      outlineVariant: Color(0xffbbc4c6),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inversePrimary: Color(0xff005249),
      primaryFixed: Color(0xffb3f5ed),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff57e0ce),
      onPrimaryFixedVariant: Color(0xff001512),
      secondaryFixed: Color(0xffdbe1ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb6c4ff),
      onSecondaryFixedVariant: Color(0xff000a4c),
      tertiaryFixed: Color(0xff9ef2e3),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff82d5c8),
      onTertiaryFixedVariant: Color(0xff001511),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff4b5152),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1b2122),
      surfaceContainer: Color(0xff2b3133),
      surfaceContainerHigh: Color(0xff363c3e),
      surfaceContainerHighest: Color(0xff424849),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}