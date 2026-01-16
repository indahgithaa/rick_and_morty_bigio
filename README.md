# Rick and Morty App

![App Thumbnail](assets/foto_thumbnail.png)

## Introduction

Rick and Morty App adalah aplikasi mobile yang dikembangkan menggunakan Flutter untuk menampilkan daftar karakter dari serial animasi Rick and Morty. Aplikasi ini dibuat sebagai bagian dari **BIGIO Intern Mobile Dev Take Home Test**.

**APK Download:** [https://drive.google.com/drive/folders/1I5yrO7dPD1rlAQd8btaPCHaEUpoe-pcm?usp=drive_link](https://drive.google.com/drive/folders/1I5yrO7dPD1rlAQd8btaPCHaEUpoe-pcm?usp=drive_link)

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Libraries](#libraries)
- [Project Structure](#project-structure)
- [APK Link](#apk-link)
- [Getting Started](#getting-started)

## Features

- **List of Characters**: Menampilkan daftar karakter dari Rick and Morty API dengan pagination
- **Detail Character**: Menampilkan informasi detail dari setiap karakter
- **Search Character**: Fitur pencarian karakter berdasarkan nama
- **Favorite Character**: Menyimpan karakter favorit secara lokal menggunakan SQLite
- **Offline Support**: Data favorit dapat diakses tanpa koneksi internet
- **Clean Architecture**: Implementasi clean architecture dengan separation of concerns
- **State Management**: Menggunakan Provider untuk state management
- **Responsive UI**: Tampilan yang responsive dan user-friendly

## Libraries

Aplikasi ini menggunakan berbagai library dan dependencies:

- **Flutter** (version 3.9.2)
- **Provider** - State Management
- **Dio** - HTTP Client untuk API calls
- **SQLite** - Local database untuk menyimpan data favorit
- **Equatable** - Value equality untuk Dart objects
- **Path** - Manipulasi file dan directory paths
- **Mocktail** - Testing library untuk unit tests
- **Flutter Launcher Icons** - Generate app icons
- **Flutter Native Splash** - Generate native splash screens

## Project Structure

```
lib/
├── main.dart
└── src/
    ├── core/
    │   ├── database/          # SQLite database implementation
    │   ├── di/                # Dependency injection
    │   ├── extensions/        # Dart extensions
    │   ├── network/           # API client & network layer
    │   ├── router/            # App routing configuration
    │   ├── state/             # State management helpers
    │   └── theme/             # App theme & styling
    └── features/
        ├── character/         # Character feature module
        │   ├── data/          # Data sources & repositories
        │   ├── domain/        # Business logic & entities
        │   └── presentation/  # UI & widgets
        └── splash/            # Splash screen feature
```

## APK Link

Download APK aplikasi ini melalui Google Drive:

**[Download APK](https://drive.google.com/drive/folders/1I5yrO7dPD1rlAQd8btaPCHaEUpoe-pcm?usp=drive_link)**

## Getting Started

### Prerequisites

- Flutter SDK 3.9.2 atau lebih tinggi
- Dart SDK
- Android Studio / VS Code
- Android SDK / iOS SDK

### Installation

1. Clone repository ini:
```bash
git clone <repository-url>
cd rick_and_morty_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run aplikasi:
```bash
flutter run
```

### Running Tests

```bash
flutter test
```

## API Reference

Aplikasi ini menggunakan [Rick and Morty API](https://rickandmortyapi.com/):
- Base URL: `https://rickandmortyapi.com/api`

## License

This project is created for educational purposes as part of BIGIO Intern Mobile Dev Take Home Test.
