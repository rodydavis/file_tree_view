# File Tree View Flutter Package

A Flutter package to view directories and files in a foldable tree structure. This package allows you to display files and folders in a tree view, with the ability to customize the folder and file icons, text styles, and handle file taps.

## Features

- **Folder and File Tree Structure**: Display files and folders in a nested tree layout.
- **Foldable Directories**: Allow users to expand and collapse directories.
- **Custom Icons**: Easily customize folder and file icons.
- **Custom Text Styles**: Style folder and file names using `TextStyle`.
- **File Tap Handler**: Handle file taps to perform custom actions.

## Getting Started

To get started, add the `file_tree_view` package to your `pubspec.yaml` file:

```yaml
dependencies:
  file_tree_view: ^1.0.0
```
## Basic Usage
```dart
import 'package:file_tree_view/file_tree_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('File Tree View')),
        body: DirectoryTreeViewer(
          rootPath: '/path/to/your/directory',  // Specify the root directory path
          onFileTap: (file) {
            // Handle file tap action
            print('Tapped on file: ${file.path}');
          },
        ),
      ),
    );
  }
}

```

## Custom Icons and TextStyle
```dart
import 'package:file_tree_view/file_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('File Tree View')),
        body: DirectoryTreeViewer(
          rootPath: '/path/to/your/directory',
          folderClosedIcon:Icon(FontAwesomeIcons.folder),
          folderClosedIcon:SvgPicture.asset('assets/your_icon.svg'), //SVG,PNG and Icon() are supported
          fileIcon:Icon(Icons.insert_drive_file),
          onFileTap: (file) {
            print('Tapped on file: ${file.path}');
          },
        ),
      ),
    );
  }
}

```
