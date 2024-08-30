# Flutter Base: Clean Architecture

### Introduce

Build and develop projects using Clean Architecture, along with several packages for generating code.

![alt text](https://github.com/LaiKhai/flutter_base/blob/main/flutter_base_project/clean-architecture.jpeg?raw=true)

**Clean Architecture** is a software design philosophy that aims to create systems that are easy to maintain, test, and understand. Introduced by Robert C. Martin (also known as Uncle Bob), it emphasizes the separation of concerns, promoting the idea that the business logic, application logic, and interface should be decoupled from each other.

## Techical in Project

- Architech: Clean Architecture
- Rest API: Dio
- Design Pattern: Bloc
- DI (Dependency Injection): Get_it, Injectable
- Assets generator: Localization (translate), flutter_gen (auto gen assets folder)

## Install

### Localization

This section provides a tutorial on how to create and internationalize a new Flutter application, along with any additional setup that a target platform might require.

To use flutter_localizations, add the package as a dependency to your pubspec.yaml file, as well as the intl package:

```ruby
flutter pub add flutter_localizations --sdk=flutter

flutter pub add intl:any

```

This creates a pubspec.yml file with the following entries:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any
```

Open the pubspec.yaml file and enable the generate flag. This flag is found in the flutter section in the pubspec file

```yaml
# The following section is specific to Flutter.
flutter:
  generate: true # Add this line
```

Add a new yaml file to the root directory of the Flutter project. Name this file **l10n.yaml** and include following content:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

Add the import statement on app_localizations.dart and AppLocalizations.delegate in your call to the constructor for MaterialApp:

```dart
const MaterialApp(
  title: 'Localizations Sample App',
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
);
```

### Flutter Gen

Works with macOS and Linux.

```ruby
brew install FlutterGen/tap/fluttergen
```

Works with macOS, Linux and Windows.

```ruby
dart pub global activate flutter_gen
```

Add build_runner and FlutterGen to your package's pubspec.yaml file:

```yaml
dev_dependencies:
  build_runner:
  flutter_gen_runner:
```

Use FlutterGen

```ruby
dart run build_runner build
```
