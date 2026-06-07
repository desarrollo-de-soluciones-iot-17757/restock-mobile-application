# Firebase Deployment Configuration

See the official documentation for more details: https://firebase.google.com/docs/flutter/setup?hl=es-419&platform=android

### Step 1: Install Firebase CLI

![step-1](https://i.imgur.com/ZZ1JE6r.png)

Go to this Url to install the Firebase CLI: https://firebase.google.com/docs/cli?hl=es-419&authuser=0&_gl=1*1q8lmcf*_ga*NzkwNTUyMzQ2LjE3NzQ4NTMyODM.*_ga_CW55HF8NVT*czE3ODA3OTA4MjUkbzI0JGcxJHQxNzgwNzkxMjA3JGo2MCRsMCRoMA..#install_the_firebase_cli


### Step 2: Install and execute the FlutterFire CLI

Only the first command to add the FlutterFire CLI to your system, the second command is to execute the configuration of the Firebase project in your Flutter project **(I already did it, so you can skip the second command if you want).**

follow this command to install the FlutterFire CLI:

```
dart pub global activate flutterfire_cli
```

![step-2](https://i.imgur.com/lELaBMG.png)

### Step 3: Access to Firebase with CLI

Follow this command to access to Firebase with CLI:

```
firebase login
```

![step-3](https://i.imgur.com/TPWxqDu.png)


### Step 4: Configure the apps to use Firebase

Follow this command:

```
flutterfire configure
```

This command generates the `firebase_options.dart` file in the `lib` folder, which contains all the necessary configuration for the Firebase services to work in your Flutter project.

In addition, the FlutterFire CLI automatically configures the platform-specific Firebase files, such as:
- google-services.json for Android
- GoogleService-Info.plist for iOS

![step-4](https://i.imgur.com/K5Ipjc2.png)
