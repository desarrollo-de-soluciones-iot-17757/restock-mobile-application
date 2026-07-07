# Restock Mobile Application

Aplicación móvil oficial de **Restock**, desarrollada con **Flutter**, orientada a consumir los servicios de la plataforma Restock y brindar soporte móvil para la gestión operativa del inventario. El proyecto está preparado para autenticación, consumo de API REST, almacenamiento seguro, persistencia local, selección de imágenes y notificaciones push mediante Firebase Cloud Messaging.

---

## Tabla de contenidos

- [Restock Mobile Application](#restock-mobile-application)
  - [Tabla de contenidos](#tabla-de-contenidos)
  - [Descripción](#descripción)
  - [Tecnologías principales](#tecnologías-principales)
  - [Estructura del proyecto](#estructura-del-proyecto)
  - [Requisitos previos](#requisitos-previos)
  - [Instalación](#instalación)
  - [Variables de entorno](#variables-de-entorno)
  - [Ejecución local](#ejecución-local)
  - [Configuración de Firebase](#configuración-de-firebase)
  - [Compilación para Android](#compilación-para-android)
  - [Firma de APK release](#firma-de-apk-release)
  - [Buenas prácticas del repositorio](#buenas-prácticas-del-repositorio)
  - [Documentación adicional](#documentación-adicional)

---

## Descripción

**Restock Mobile Application** es el cliente móvil de la plataforma Restock. Su objetivo es facilitar el acceso desde dispositivos móviles a funcionalidades relacionadas con la gestión de inventarios, integración con servicios backend y recepción de notificaciones relevantes para la operación.

El proyecto utiliza una arquitectura Flutter modular apoyada en herramientas de navegación, gestión de estado, inyección de dependencias, almacenamiento seguro y comunicación HTTP.

---

## Tecnologías principales

- **Flutter** / **Dart**
- **flutter_bloc** para gestión de estado
- **go_router** para navegación declarativa
- **get_it** para inyección de dependencias
- **http** para consumo de API REST
- **flutter_secure_storage** para almacenamiento seguro de credenciales o tokens
- **sqflite** para persistencia local
- **cached_network_image** y **flutter_cache_manager** para manejo eficiente de imágenes remotas
- **image_picker** para selección o captura de imágenes
- **Firebase Core** y **Firebase Messaging** para notificaciones push
- **flutter_local_notifications** para notificaciones locales
- **lottie** para animaciones
- **Kotlin / Android Gradle Kotlin DSL** para configuración Android

---

## Estructura del proyecto

```text
restock-mobile-application/
├── android/                         # Configuración nativa Android
├── ios/                             # Configuración nativa iOS
├── web/                             # Configuración para Flutter Web
├── linux/                           # Configuración para Linux desktop
├── macos/                           # Configuración para macOS desktop
├── windows/                         # Configuración para Windows desktop
├── assets/
│   ├── icon/                        # Íconos de la aplicación
│   ├── images/                      # Imágenes usadas por la app
│   ├── lottie/                      # Animaciones Lottie
│   └── notifications/               # Recursos gráficos para notificaciones
├── docs/
│   ├── enviroment_variables.md      # Guía de variables de entorno
│   └── firebase_deployment.md       # Guía de configuración Firebase
├── lib/                             # Código fuente Flutter/Dart
│   └── main.dart                    # Punto de entrada de la aplicación
├── pubspec.yaml                     # Dependencias y configuración Flutter
├── analysis_options.yaml            # Reglas de análisis estático
├── LICENSE.md                       # Licencia del proyecto
└── README.md                        # Documentación principal
```

> Nota: para ejecutar el proyecto es necesario que exista `lib/main.dart`. Si el repositorio local no contiene la carpeta `lib/`, restaura el código fuente Flutter antes de ejecutar `flutter run` o `flutter build`.

---

## Requisitos previos

Antes de ejecutar el proyecto, instala y configura:

- Flutter SDK compatible con `Dart SDK ^3.11.5`
- Android Studio o Visual Studio Code con extensiones de Flutter/Dart
- Android SDK configurado
- Un emulador Android o dispositivo físico
- Firebase CLI, si se trabajará con notificaciones push
- FlutterFire CLI, si se regenerará la configuración de Firebase

Verifica tu entorno con:

```bash
flutter doctor
```

---

## Instalación

Clona el repositorio:

```bash
git clone <repository-url>
cd restock-mobile-application
```

Instala las dependencias:

```bash
flutter pub get
```

Ejecuta el análisis estático:

```bash
flutter analyze
```

Ejecuta las pruebas, si existen pruebas configuradas:

```bash
flutter test
```

---

## Variables de entorno

La URL base del backend se inyecta en tiempo de compilación mediante `--dart-define` o `--dart-define-from-file`.

Variable principal:

| Variable         | Descripción               | Ejemplo                                                 |
| ---------------- | -------------------------- | ------------------------------------------------------- |
| `API_BASE_URL` | URL base de la API Restock | `https://restock-api-17757.azurewebsites.net/api/v1/` |

Para desarrollo local, crea un archivo `.env.json` en la raíz del proyecto:

```json
{
  "API_BASE_URL": ""
}
```

Si `API_BASE_URL` está vacío, la app debe usar el fallback local definido en el código:

| Plataforma              | URL local esperada                |
| ----------------------- | --------------------------------- |
| Android Emulator        | `http://10.0.2.2:8080/api/v1/`  |
| iOS Simulator / Desktop | `http://127.0.0.1:8080/api/v1/` |

Para probar contra el backend desplegado, completa el archivo `.env.json`:

```json
{
  "API_BASE_URL": "https://restock-api-17757.azurewebsites.net/api/v1/"
}
```

---

## Ejecución local

Ejecutar con configuración local por defecto:

```bash
flutter run
```

Ejecutar usando variables desde `.env.json`:

```bash
flutter run --dart-define-from-file=.env.json
```

Ejecutar apuntando directamente al backend desplegado:

```bash
flutter run --dart-define=API_BASE_URL="https://restock-api-17757.azurewebsites.net/api/v1/"
```

---

## Configuración de Firebase

El proyecto está preparado para usar Firebase, principalmente para **Firebase Cloud Messaging** y notificaciones locales.

Instala Firebase CLI e inicia sesión:

```bash
firebase login
```

Instala FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

Configura Firebase para el proyecto:

```bash
flutterfire configure --project=uitopic-1406c
```

Este proceso puede generar archivos como:

```text
lib/firebase_options.dart
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
firebase.json
```

Por seguridad, estos archivos pueden estar ignorados por Git y deben ser generados localmente o inyectados desde secretos de CI/CD cuando corresponda.

---

## Compilación para Android

Compilar APK release usando backend desplegado:

```bash
flutter build apk --release \
  --dart-define=API_BASE_URL="https://restock-api-17757.azurewebsites.net/api/v1/"
```

Compilar usando `.env.json`:

```bash
flutter build apk --release --dart-define-from-file=.env.json
```

El APK generado normalmente se encontrará en:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## Firma de APK release

La configuración Android permite firmar el APK release mediante variables de entorno.

Variables esperadas:

| Variable                                   | Descripción              |
| ------------------------------------------ | ------------------------- |
| `KEYSTORE_PATH` o `KEYSTORE_FILE_PATH` | Ruta del archivo keystore |
| `KEYSTORE_PASSWORD`                      | Contraseña del keystore  |
| `KEY_ALIAS`                              | Alias de la llave         |
| `KEY_PASSWORD`                           | Contraseña de la llave   |

Ejemplo en terminal:

```bash
export KEYSTORE_PATH="/path/to/release-key.jks"
export KEYSTORE_PASSWORD="your-keystore-password"
export KEY_ALIAS="your-key-alias"
export KEY_PASSWORD="your-key-password"

flutter build apk --release \
  --dart-define=API_BASE_URL="https://restock-api-17757.azurewebsites.net/api/v1/"
```

Si estas variables no están configuradas, el build release puede usar la firma debug como fallback. Para distribución real, se recomienda usar firma release válida.

---

## Buenas prácticas del repositorio

No subir archivos generados, credenciales ni artefactos locales. Verifica que permanezcan fuera del control de versiones:

```text
build/
.dart_tool/
.env.json
firebase.json
lib/firebase_options.dart
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
android/local.properties
*.jks
*.p12
*.mobileprovision
```

Antes de realizar commit, se recomienda ejecutar:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
```

También se recomienda no versionar carpetas generadas como `build/`, `.gradle/`, `.cxx/` o archivos locales con rutas absolutas del equipo.

---

## Documentación adicional

El proyecto incluye documentación complementaria en la carpeta `docs/`:

- `docs/enviroment_variables.md`: explicación del manejo de `API_BASE_URL` mediante `--dart-define`.
- `docs/firebase_deployment.md`: pasos para configurar Firebase CLI y FlutterFire CLI.
