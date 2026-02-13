# magic_answer_book

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Test Automation

To keep regressions from reaching release builds, run tests through the shared script:

```bash
./tool/run_tests.sh
```

In CI, configure your pipeline to execute this script on every push and pull request so that `flutter test` is always enforced.
