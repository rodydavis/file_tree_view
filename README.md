# File Tree View Flutter Package

A Flutter package to view directories and files in a foldable tree structure. This package allows you to display files and folders in a tree view, with the ability to customize the folder and file icons, text styles, and handle file taps.

## Features

- **Folder and File Tree Structure**: Display files and folders in a nested tree layout.
- **Foldable Directories**: Allow users to expand and collapse directories.
- **Custom Icons**: Easily customize foldaer and file icons.
- **Custom Text Styles**: Style folder and file names using `TextStyle`.
- **File Tap Handler**: Handle file taps to perform custom actions.

| Platform   | Supported  |
|------------|------------|
| **Android** | ✓          |
| **iOS**     | ✓          |
| **Windows** | ✓          |
| **Linux**   | ✓          |
| **macOS**   | ✓          |
| **Web**     | ✘          |

_Note_: This package is not currently compatible with Web. 

<br>

<img src="https://i.imgur.com/CIw6251.gif" alt="gif" width="210" height="390" style="padding-right:45px"/>
<img src = "https://i.imgur.com/dKUlq8v.gif" alt="gif" width="210" height="390"/>


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
        body: DirectoryTreeViewer(rootPath: '/path/to/your/directory'), // Specify the root directory path
      ),
    );
  }
}

```

## Custom Icons and TextStyle
```dart
import 'package:file_tree_view/file_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:file_icon/file_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(
    const MaterialApp(
      home:  Home()
    ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181818),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      drawer: Drawer(
        backgroundColor:  const Color(0xff2b2b2b),
        child: SingleChildScrollView(
          child: SizedBox(
            child: DirectoryTreeViewer(
              rootPath: '/home/athul/Projects/AndroidApps/apps/survey_app', //Adjust the root path to desired folder
              folderNameStyle: const TextStyle(color: Colors.grey),
              fileNameStyle: const TextStyle(color: Colors.grey),
              folderClosedicon: SvgPicture.asset('assets/folder.svg',height: 28,width: 28),
              folderOpenedicon: SvgPicture.asset('assets/open-file-folder.svg',height: 28,width: 28),
              fileIconBuilder: (extension)=>FileIcon(extension),
          ),    
          ),
        ),
      ),
      body: const Center(child: Text("Example with custom icons",style: TextStyle(color: Colors.grey))),
    );
  }
}


```
