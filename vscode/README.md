# dart-comma-injector

A vscode extension to inject commas to the end of dart parameter and argument lists


## Extension Settings

This extension contributes the following settings:
* `dartCommaInjector.executable`: a path to an executable that will be used to run the "dart comma injector" process
    - This is commonly used to improve preformance of the command by compiling the dart cli `dart compile exe cli/bin/main.dart`, and then specifying the path in this setting: `/path/to/dart_comma_injector/cli/bin/main.exe`. This will improve the preformance of running the injection a fair amount
* `dartCommaInjector.postRunExecutable`: a command that is run directly after executing the dart comma injector process, frequently used for formatting the current file
    - the wildcard `<filepath>` will be replaced with the file path that the injector was used on
    - if you are using [`dart_dev`](https://github.com/Workiva/dart_dev), this can be set to: `dart run dart_dev hackFastFormat <filepath>`, for preformant formatting
