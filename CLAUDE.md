# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application called "元夕" (Yuan Xi) - a customizable web content parser and reader designed for parsing novel/book content from websites using custom rules. It's built with Flutter and uses Riverpod for state management.

## Common Development Commands

### Building the Application

```bash
# Android APK
flutter build apk

# Android App Bundle (for Play Store)
flutter build appbundle

# iOS
flutter build ipa

# macOS
flutter build macos

# Windows
flutter build windows
```

### Code Generation

The project uses several code generation tools that need to be run after modifying related files:

```bash
# Generate all code (run after modifying routes, models, or providers)
flutter pub run build_runner build

# Generate with deletion of previous generated files
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes and generate automatically
flutter pub run build_runner watch
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/your_test_file.dart
```

### Linting and Analysis

```bash
# Run Flutter analysis
flutter analyze

# Run linter
flutter pub run flutter_lints
```

## Architecture

### State Management
- **Riverpod**: Primary state management solution
- **GetIt**: Dependency injection for ViewModels
- **Signals**: Used for reactive state management in some components

### Database
- **Isar**: Local NoSQL database for storing:
  - Books and reading progress
  - Source rules and configurations
  - User settings and themes
  - Available sources
- **Migration system**: Database migrations in `lib/database/migration/`

### Core Components

#### Database Layer (`lib/database/`)
- `service.dart`: Main database service
- Various service classes for different entities (BookService, SourceService, etc.)
- Migration system for schema changes

#### Pages (`lib/page/`)
- **Home**: Bookshelf, explore, and profile views
- **Reader**: Main reading interface with multiple turning modes
- **Source Management**: Create, edit, and manage parsing sources
- **Settings**: App configuration and theme management

#### Parsing Engine
- **XPath/JSONPath**: Web content parsing rules
- **Custom pipeline functions**: For data processing
- **Source system**: JSON-based configuration for different websites

#### Dependency Injection (`lib/di.dart`)
- GetIt instance manages all ViewModels
- Factory and singleton registrations
- Cached factories for performance optimization

### Key Features

1. **Custom Source System**: Users can create custom parsing rules for any website using XPath/JSONPath
2. **Reading Interface**: Multiple page-turning animations and reading modes with cache support
3. **Theme System**: Customizable themes with editor for reader customization
4. **Cloud Sync**: iCloud integration for multi-device sync of books and settings
5. **Text Replacement**: Custom text replacement rules for content cleanup and formatting
6. **Source Management**: Import/export source configurations and manage multiple sources

### File Structure

```
lib/
├── database/           # Database services and migrations
├── page/              # UI pages and view models
│   ├── reader/        # Reading interface components
│   ├── home/          # Home screen (bookshelf, explore, profile)
│   └── ...           # Other feature pages
├── schema/            # Isar database schemas
├── model/             # Data models and entities
├── widget/            # Reusable UI components
├── util/              # Utility functions
└── di.dart           # Dependency injection setup
```

## Development Notes

### Code Generation Requirements
- Run `flutter pub run build_runner build` after modifying:
  - Routes (auto_route)
  - Database schemas (Isar)
  - Providers (Riverpod)
  - Models with annotations

### Database Migrations
- Add new migration files in `lib/database/migration/`
- Follow naming convention: `migration_YYYYMMDDHHMM.dart`
- Update the migration service to include new migrations

### Source System
- Sources are defined in JSON format with fields like `source_name`, `source_url`, `search_books`, etc.
- Support XPath and JSONPath parsing rules
- Include pipeline functions for data transformation
- Examples in `asset/` directory (`sources.json`, `biquge_source.json`)
- Tutorial documentation in `doc/` directory with comprehensive guides

### Theme System
- Custom themes stored in database
- Theme editor for user customization
- Support for light/dark mode
- Reader-specific themes with font and layout controls
- Theme switching and customization options

### Additional Development Notes
- The project includes comprehensive documentation in `doc/` directory for source creation
- Text replacement system allows users to define custom replacement rules
- Cache system for offline reading of downloaded content
- Support for multiple book formats and web content parsing