@echo off
echo Checking Flutter...
flutter --version
if errorlevel 1 (
  echo Flutter পাওয়া যাচ্ছে না। আগে Flutter SDK install করুন।
  pause
  exit /b 1
)
echo Getting packages...
flutter pub get
echo.
echo Available devices:
flutter devices
echo.
echo To run: flutter run
pause
