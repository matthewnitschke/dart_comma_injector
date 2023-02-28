# dart-comma-injector

A cli tool to inject commas at the end of parameter and argument lists, because it looks so much better with a comma at the end

## Installation

```sh
dart pub global activate dart-comma-injector
```

## Why

The default dart formatter does some weird things with long parameter lists

This
```dart
void func(String a, String b, String c, String d, String e, String f, String g, String h) {}
```

Becomes this after running `dart format`
```dart
void func(String a, String b, String c, String d, String e, String f, String g,
    String h) {}
```

Which is subjectively ugly

One way to improve this, is to put a comma at the end of the parameter list, which will format the function like so after format
```dart
void func(
    String a, 
    String b, 
    String c, 
    String d, 
    String e, 
    String f, 
    String g,
    String h,
) {}
```

Because I'm lazy, this cli tool (which is designed to be run from a IDE extension), will inject a comma at the end of the list, so the formatter outputs prettier results