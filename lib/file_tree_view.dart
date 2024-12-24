import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// A widget to display a directory tree structure with foldable directories and customizable file/folder icons and text styles.
class DirectoryTreeViewer extends StatelessWidget {
  /// The root path of the directory to display.
  final String rootPath;

  /// Callback function when a file is tapped. Accepts a [File] as parameter.
  final void Function(File)? onFileTap;

  /// The icon for closed folders. Default is a folder icon.
  final dynamic folderClosedicon;

  /// The icon for opened folders. Default is a folder opened icon.
  final dynamic folderOpenedicon;

  /// The icon for files. Default is a generic file icon.
  final dynamic fileIcon;

  /// The text style for folder names. Default is an empty [TextStyle].
  final TextStyle folderNameStyle;

  /// The text style for file names. Default is an empty [TextStyle].
  final TextStyle fileNameStyle;

  /// A function that returns a custom file icon based on the file extension.
  final Widget Function(String fileExtension)? fileIconBuilder;

  /// Constructs a [DirectoryTreeViewer] with the given properties.
  const DirectoryTreeViewer({
    super.key,
    required this.rootPath,
    this.onFileTap,
    this.folderClosedicon = const Icon(Icons.folder),
    this.folderOpenedicon = const Icon(Icons.folder_open),
    this.fileIcon = const Icon(Icons.insert_drive_file),
    this.folderNameStyle = const TextStyle(),
    this.fileNameStyle = const TextStyle(),
    this.fileIconBuilder,
  });

  @override
  Widget build(BuildContext context) {
    /// Check if the platform is Web or WASM, and display a message if it is.
    if (kIsWasm || kIsWeb) {
      return const AlertDialog(
        title: Text("Web platform is not supported"),
      );
    }
    return DirectoryTreeStateProvider(
      notifier: DirectoryTreeStateNotifier(),
      child: FoldableDirectoryTree(
        rootPath: rootPath,
        fileIcon: fileIcon,
        folderNameStyle: folderNameStyle,
        fileNameStyle: fileNameStyle,
        folderClosedicon: folderClosedicon,
        folderOpenedicon: folderOpenedicon,
        onFileTap: onFileTap,
        fileIconBuilder: fileIconBuilder,
      ),
    );
  }
}

/// A notifier to manage the state of folded or unfolded directories.
class DirectoryTreeStateNotifier extends ChangeNotifier {
  /// A map that stores the states (folded/unfolded) of directories.
  final Map<String, bool> _folderStates = {};

  /// Returns true if the directory is unfolded, otherwise false.
  bool isUnfolded(String dirPath) => _folderStates[dirPath] ?? false;

  /// Toggles the fold state of the directory.
  void toggleFolder(String dirPath) {
    _folderStates[dirPath] = !(_folderStates[dirPath] ?? false);
    notifyListeners();
  }
}

/// A provider that supplies [DirectoryTreeStateNotifier] to its descendants in the widget tree.
class DirectoryTreeStateProvider
    extends InheritedNotifier<DirectoryTreeStateNotifier> {
  /// Constructs a [DirectoryTreeStateProvider] with the given notifier and child widget.
  const DirectoryTreeStateProvider({
    super.key,
    required DirectoryTreeStateNotifier super.notifier,
    required super.child,
  });

  /// Accesses the [DirectoryTreeStateNotifier] in the widget tree.
  static DirectoryTreeStateNotifier of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<DirectoryTreeStateProvider>();
    assert(provider != null, 'No DirectoryTreeStateProvider found in context');
    return provider!.notifier!;
  }
}

/// A widget that displays a foldable directory tree, showing files and subdirectories.
class FoldableDirectoryTree extends StatelessWidget {
  /// The root path of the directory to display.
  final String rootPath;

  /// A callback function for when a file is tapped. Accepts a [File] as parameter.
  final void Function(File)? onFileTap;

  /// The icon for closed folders. Required.
  final dynamic folderClosedicon;

  /// The icon for opened folders. Required.
  final dynamic folderOpenedicon;

  /// The icon for files. Required.
  final dynamic fileIcon;

  /// The text style for folder names. Required.
  final TextStyle folderNameStyle;

  /// The text style for file names. Required.
  final TextStyle fileNameStyle;

  /// A function that returns a custom file icon based on the file extension.
  final Widget Function(String fileExtension)? fileIconBuilder;

  /// Constructs a [FoldableDirectoryTree] with the given properties.
  const FoldableDirectoryTree({
    super.key,
    required this.rootPath,
    this.onFileTap,
    required this.folderClosedicon,
    required this.folderOpenedicon,
    required this.fileIcon,
    required this.folderNameStyle,
    required this.fileNameStyle,
    this.fileIconBuilder,
  });

  /// Recursively builds the directory tree for a given [directory] using [stateNotifier] to manage folder states.
  Widget _buildDirectoryTree(
      Directory directory, DirectoryTreeStateNotifier stateNotifier) {
    final entries = directory.listSync();
    entries.sort((a, b) {
      if (a is Directory && b is File) return -1;
      if (a is File && b is Directory) return 1;
      return a.path.compareTo(b.path);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => stateNotifier.toggleFolder(directory.path),
          child: Row(
            children: [
              stateNotifier.isUnfolded(directory.path)
                  ? folderOpenedicon
                  : folderClosedicon,
              const SizedBox(width: 8),
              Text(path.basename(directory.path), style: folderNameStyle),
            ],
          ),
        ),
        if (stateNotifier.isUnfolded(directory.path))
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: entries.map((entry) {
                if (entry is Directory) {
                  return _buildDirectoryTree(
                      Directory(entry.path), stateNotifier);
                } else if (entry is File) {
                  return _buildFileItem(entry);
                }
                return const SizedBox.shrink();
              }).toList(),
            ),
          ),
      ],
    );
  }

  /// Builds the widget for a single file item.
  Widget _buildFileItem(File file) {
    final extension = path.extension(file.path).toLowerCase();
    final customIcon =
        fileIconBuilder != null ? fileIconBuilder!(extension) : fileIcon;
    return InkWell(
      onTap: () {
        if (onFileTap != null) {
          onFileTap!(file);
        }
      },
      child: Row(
        children: [
          customIcon,
          const SizedBox(width: 8),
          Text(
            path.basename(file.path),
            style: fileNameStyle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stateNotifier = DirectoryTreeStateProvider.of(context);

    final rootDirectory = Directory(rootPath);

    if (!rootDirectory.existsSync()) {
      return const Center(
        child: Text('Directory does not exist'),
      );
    }

    return SingleChildScrollView(
      child: _buildDirectoryTree(rootDirectory, stateNotifier),
    );
  }
}
