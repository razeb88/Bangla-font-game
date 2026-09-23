# মোবাইল থেকে APK বানানোর সবচেয়ে সহজ নিয়ম

1. GitHub-এ একটি account খুলুন: https://github.com/
2. New repository তৈরি করুন, যেমন `bangla-letter-archery`
3. এই ZIP-এর ভিতরের project files repository-তে upload করুন।
   - ZIP file নিজে upload করবেন না।
   - `pubspec.yaml`, `lib/`, `.github/` ইত্যাদি repository root-এ থাকবে।
4. GitHub-এ repository খুলে **Actions** tab চাপুন।
5. **Build Android APK** workflow নির্বাচন করুন।
6. **Run workflow** চাপুন।
7. Build শেষ হলে workflow-এর নিচে **Artifacts** থেকে
   `bangla-letter-archery-apk` download করুন।
8. ZIP extract করলে `app-release.apk` পাবেন।
9. APK ফোনে install করুন।

নোট:
- আপনার ফোনে Android Studio বা Flutter SDK লাগবে না।
- GitHub-এর server Flutter/Android build করবে।
- প্রথমবার GitHub যদি Actions enable করতে বলে, Enable/Allow করুন।
- APK install করার সময় Android "Install unknown apps" permission চাইতে পারে।
