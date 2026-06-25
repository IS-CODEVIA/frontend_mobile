import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/settings_option_model.dart';

final settingsOptionsProvider = Provider<List<SettingsOptionModel>>((ref) {
  return [
    SettingsOptionModel(
      title: 'Notificaciones',
      subtitle: 'Configurar notificaciones push',
      icon: Icons.notifications_outlined,
    ),
    SettingsOptionModel(
      title: 'Apariencia',
      subtitle: 'Tema claro/oscuro',
      icon: Icons.palette_outlined,
    ),
    SettingsOptionModel(
      title: 'Idioma',
      subtitle: 'Español - ES',
      icon: Icons.language_outlined,
    ),
    SettingsOptionModel(
      title: 'Privacidad',
      subtitle: 'Datos personales y seguridad',
      icon: Icons.lock_outline,
    ),
    SettingsOptionModel(
      title: 'Acerca de',
      subtitle: 'Versión 1.0.0',
      icon: Icons.info_outline,
    ),
  ];
});
