import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage {
  it('it', 'Italiano (IT)', '🇮🇹'),
  en('en', 'English (EN)', '🇬🇧');

  final String code;
  final String label;
  final String flag;

  const AppLanguage(this.code, this.label, this.flag);

  static AppLanguage fromCode(String? code) {
    if (code == null) return AppLanguage.it;
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code.toLowerCase().trim(),
      orElse: () => AppLanguage.it,
    );
  }
}

class AppLanguageNotifier extends StateNotifier<AppLanguage> {
  AppLanguageNotifier() : super(AppLanguage.it) {
    _load();
  }

  File? _getStorageFile() {
    if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) return null;
    try {
      final env = Platform.environment;
      final home = Platform.isWindows
          ? (env['USERPROFILE'] ?? 'C:\\Users\\Default')
          : (env['HOME'] ?? '/tmp');
      final dir = Directory('$home/.piframe');
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      return File('${dir.path}/language_settings.json');
    } catch (_) {
      return null;
    }
  }

  void _load() {
    final file = _getStorageFile();
    if (file != null && file.existsSync()) {
      try {
        final content = file.readAsStringSync();
        final map = jsonDecode(content) as Map<String, dynamic>;
        state = AppLanguage.fromCode(map['language']?.toString());
      } catch (_) {}
    }
  }

  void _save() {
    final file = _getStorageFile();
    if (file != null) {
      try {
        file.writeAsStringSync(jsonEncode({'language': state.code}));
      } catch (_) {}
    }
  }

  void setLanguage(AppLanguage language) {
    if (state != language) {
      state = language;
      _save();
    }
  }
}

final appLanguageProvider =
    StateNotifierProvider<AppLanguageNotifier, AppLanguage>((ref) {
      return AppLanguageNotifier();
    });

class AppStrings {
  final AppLanguage language;

  const AppStrings(this.language);

  bool get isItalian => language == AppLanguage.it;

  // Settings Header & General
  String get settingsTitle =>
      isItalian ? 'Impostazioni PiFrame' : 'PiFrame Settings';
  String get backToChatTooltip =>
      isItalian ? 'Torna alla conversazione' : 'Back to conversation';
  String get cancel => isItalian ? 'Annulla' : 'Cancel';
  String get save => isItalian ? 'Salva' : 'Save';
  String get close => isItalian ? 'Chiudi' : 'Close';

  // Tabs
  String get tabPiCli => 'PI CLI';
  String get tabPackages => isItalian ? 'PACCHETTI' : 'PACKAGES';
  String get tabDaemon => 'DAEMON';
  String get tabAppearance => isItalian ? 'ASPETTO' : 'APPEARANCE';
  String get tabPrivacy => 'PRIVACY';
  String get tabDiagnostics => isItalian ? 'DIAGNOSTICA' : 'DIAGNOSTICS';
  String get tabUpdates => isItalian ? 'AGGIORNAMENTI' : 'UPDATES';
  String get tabTerminal => isItalian ? 'TERMINALE' : 'TERMINAL';
  String get tabRemote => isItalian ? 'ACCESSO REMOTO' : 'REMOTE ACCESS';

  String get updateAllPackages => isItalian ? 'Aggiorna tutto' : 'Update all';
  String get updatingPackages => isItalian ? 'Aggiornamento...' : 'Updating...';
  String get updateAllPackagesTitle =>
      isItalian ? 'Aggiornare tutti i pacchetti?' : 'Update all packages?';
  String updateAllPackagesMessage(int count) => isItalian
      ? 'Pi aggiornerà i $count pacchetti utente con aggiornamenti disponibili. Le versioni bloccate non verranno modificate. Le modifiche saranno attive al prossimo avvio di Pi.'
      : 'Pi will update the $count user packages with available updates. Pinned versions will not be changed. Changes will take effect the next time Pi starts.';
  String packagesUpdated(int count) => isItalian
      ? 'Tutti i $count pacchetti sono stati aggiornati.'
      : 'All $count packages have been updated.';
  String packageUpdatesFailed(int updated, int failed) => isItalian
      ? 'Pacchetti aggiornati: $updated. Aggiornamenti non riusciti: $failed.'
      : 'Packages updated: $updated. Updates failed: $failed.';
  String packageUpdateSummary(int updated, int current, int pinned) => isItalian
      ? 'Pacchetti aggiornati: $updated. Già aggiornati: $current. Versione bloccata: $pinned.'
      : 'Packages updated: $updated. Already up to date: $current. Version pinned: $pinned.';
  String packageUpdateFailures(int count) => isItalian
      ? 'Aggiornamenti non riusciti: $count.'
      : 'Updates failed: $count.';
  String packageAlreadyCurrent(String source, String? version) => isItalian
      ? '$source è già aggiornato${version == null ? '' : ' ($version)'}.'
      : '$source is already up to date${version == null ? '' : ' ($version)'}.';
  String packageVersionPinned(String source, String? version) => isItalian
      ? '$source mantiene la versione bloccata${version == null ? '' : ' ($version)'}.'
      : '$source keeps its pinned version${version == null ? '' : ' ($version)'}.';
  String packageVersionUpdated(String source, String? before, String? after) =>
      isItalian
      ? 'Pacchetto aggiornato: $source${before == null || after == null ? '' : ' ($before → $after)'}.'
      : 'Package updated: $source${before == null || after == null ? '' : ' ($before → $after)'}.';
  String get packageUpdateNotVerified => isItalian
      ? 'Il daemon non ha verificato la versione installata. Riavvia il daemon aggiornato prima di riprovare.'
      : 'The daemon did not verify the installed version. Restart the updated daemon before trying again.';
  String packageUpdateCheckFailed(String error) => isItalian
      ? 'Impossibile ricontrollare gli aggiornamenti: $error'
      : 'Unable to recheck updates: $error';
  String packageUpdateUnavailable(String version, String error) => isItalian
      ? 'Aggiornamento $version non compatibile con questa piattaforma. $error'
      : 'Update $version is not compatible with this platform. $error';
  String get restartPiAfterPackageUpdate => isItalian
      ? 'Riavvia Pi per applicare le modifiche.'
      : 'Restart Pi to apply the changes.';
  String get packagesDaemonDisconnected => isItalian
      ? 'Daemon non connesso: impossibile aggiornare i pacchetti.'
      : 'Daemon disconnected: packages cannot be updated.';

  // Appearance tab
  String get appearanceTitle =>
      isItalian ? 'Personalizzazione Tema e UI' : 'Theme & UI Customization';
  String get appearanceSubtitle => isItalian
      ? 'PiFrame supporta temi personalizzati definiti via file JSON in ~/.piframe/themes/.'
      : 'PiFrame supports custom themes defined via JSON files in ~/.piframe/themes/.';
  String get languageSectionTitle =>
      isItalian ? 'Lingua dell\'Applicazione' : 'Application Language';
  String get languageSectionSubtitle => isItalian
      ? 'Seleziona la lingua per l\'interfaccia grafica e i messaggi dell\'applicazione.'
      : 'Select the language for the graphical interface and application messages.';
  String get useSystemTheme =>
      isItalian ? 'Usa tema di sistema' : 'Use system theme';
  String get useSystemThemeSubtitle => isItalian
      ? 'Adatta automaticamente l\'aspetto in base alla modalità chiara o scura del sistema operativo.'
      : 'Automatically match appearance with operating system dark/light mode.';
  String get selectActiveTheme =>
      isItalian ? 'Seleziona Tema Attivo:' : 'Select Active Theme:';
  String get defaultDarkTheme =>
      isItalian ? 'Tema Scuro Predefinito:' : 'Default Dark Theme:';
  String get defaultLightTheme =>
      isItalian ? 'Tema Chiaro Predefinito:' : 'Default Light Theme:';
  String get importThemeBtn => isItalian
      ? 'Importa tema JSON (VSCode / PiFrame)'
      : 'Import JSON Theme (VSCode / PiFrame)';
  String get openThemeEditorBtn => isItalian
      ? 'Editor Temi / Personalizza Tema'
      : 'Theme Editor / Customize Theme';

  // Theme Editor
  String get themeEditorTitle =>
      isItalian ? 'Editor Temi Personalizzati' : 'Custom Theme Editor';
  String get themeEditorSubtitle => isItalian
      ? 'Crea un nuovo tema a partire da uno esistente, personalizzane i componenti grafici e salvalo con un nome.'
      : 'Create a new theme based on an existing one, customize visual components, and save with a custom name.';
  String get baseThemeLabel =>
      isItalian ? 'Tema di Partenza' : 'Starting Theme';
  String get themeNameLabel => isItalian ? 'Nome Tema' : 'Theme Name';
  String get themeNameHint =>
      isItalian ? 'Es. Mio Tema Scuro' : 'E.g. My Custom Dark';
  String get themeVariantLabel => isItalian ? 'Variante' : 'Variant';
  String get variantDark => isItalian ? 'Scuro (Dark)' : 'Dark';
  String get variantLight => isItalian ? 'Chiaro (Light)' : 'Light';
  String get previewLabel =>
      isItalian ? 'Anteprima Componenti' : 'Component Preview';
  String get saveThemeAction =>
      isItalian ? 'Salva e Applica Tema' : 'Save & Apply Theme';

  // Theme Editor component categories
  String get catSurfaces =>
      isItalian ? 'Superfici & Sfondo' : 'Surfaces & Background';
  String get catAccents => isItalian ? 'Accenti & Focus' : 'Accents & Focus';
  String get catText => isItalian ? 'Tipografia & Testi' : 'Typography & Text';
  String get catAgent => isItalian ? 'Stati Agente' : 'Agent States';
  String get catSyntax =>
      isItalian ? 'Evidenziazione Sintassi' : 'Syntax Highlighting';

  // Startup Update Notification
  String get updateNoticeTitle =>
      isItalian ? 'Aggiornamenti Rilevati' : 'Updates Available';
  String get updateNoticePi => isItalian
      ? 'Nuova versione di Pi CLI disponibile'
      : 'New Pi CLI version available';
  String get updateNoticePackages =>
      isItalian ? 'pacchetti con aggiornamenti' : 'packages with updates';
  String get updateNoticeOpenSettings =>
      isItalian ? 'Dettagli / Aggiorna' : 'Details / Update';
  String get updateNoticeDismiss => isItalian ? 'Ignora' : 'Dismiss';
}

final appStringsProvider = Provider<AppStrings>((ref) {
  final lang = ref.watch(appLanguageProvider);
  return AppStrings(lang);
});
