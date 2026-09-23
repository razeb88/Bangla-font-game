# বাংলা অক্ষর তীরন্দাজ — চালানোর সম্পূর্ণ নিয়ম

## আগে যা Install করবেন

### Windows PC হলে
1. **Flutter SDK** install করুন।
2. **Android Studio** install করুন।
3. Android Studio-র SDK Manager থেকে **Android SDK** এবং প্রয়োজনীয় SDK tools install করুন।
4. Terminal/CMD খুলে চালান:
   `flutter doctor`
5. যেগুলো missing দেখাবে সেগুলো install/accept করুন:
   `flutter doctor --android-licenses`

### ফোনে চালাতে চাইলে
- Android ফোনে Developer Options → USB debugging চালু করুন।
- USB cable দিয়ে PC-তে ফোন connect করুন।
- তারপর:
  `flutter devices`
  `flutter run`

### Android Studio-তে
Project folder খুলুন। প্রথমবার dependency download হতে কিছু সময় লাগতে পারে।
Terminal-এ:
`flutter pub get`
তারপর:
`flutter run`

## APK বানাতে
Terminal-এ project folder-এ গিয়ে:
`flutter build apk --release`

APK:
`build/app/outputs/flutter-apk/release/app-release.apk`

## গুরুত্বপূর্ণ
এই source ZIP-এ Flutter SDK/Android SDK ঢোকানো হয়নি—ওগুলো অনেক বড় এবং আপনার কম্পিউটারে আলাদাভাবে install করতে হয়।
এই project-এ third-party audio package ব্যবহার করা হয়নি, তাই extra audio plugin লাগবে না।

## বাংলা ফন্ট
Android-এর system font-এ বাংলা ঠিকমতো দেখানোর চেষ্টা করবে। কোনো ফোনে অক্ষর ভাঙা দেখালে Google Fonts-এর Noto Sans Bengali font project-এ যোগ করা যেতে পারে।
