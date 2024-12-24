import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

class DirectoryTreeViewer extends StatelessWidget {
  final String rootPath;
  final void Function(File)? onFileTap;
  final dynamic folderClosedicon;
  final dynamic folderOpenedicon;
  final dynamic fileIcon;
  final TextStyle folderNameStyle;
  final TextStyle fileNameStyle;
  final Widget Function(String fileExtension)? fileIconBuilder;

  const DirectoryTreeViewer(
      {super.key,
      required this.rootPath,
      this.onFileTap,
      this.folderClosedicon = const Icon(Icons.folder),
      this.folderOpenedicon = const Icon(Icons.folder_open,),
      this.fileIcon = const Icon(Icons.insert_drive_file),
      this.folderNameStyle=const TextStyle(),
      this.fileNameStyle=const TextStyle(),
      this.fileIconBuilder
      });

  @override
  Widget build(BuildContext context) {
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

class DirectoryTreeStateNotifier extends ChangeNotifier {
  final Map<String, bool> _folderStates = {};

  bool isUnfolded(String dirPath) => _folderStates[dirPath] ?? false;

  void toggleFolder(String dirPath) {
    _folderStates[dirPath] = !(_folderStates[dirPath] ?? false);
    notifyListeners();
  }
}

class DirectoryTreeStateProvider
    extends InheritedNotifier<DirectoryTreeStateNotifier> {
  const DirectoryTreeStateProvider({
    super.key,
    required DirectoryTreeStateNotifier super.notifier,
    required super.child,
  });

  static DirectoryTreeStateNotifier of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<DirectoryTreeStateProvider>();
    assert(provider != null, 'No DirectoryTreeStateProvider found in context');
    return provider!.notifier!;
  }
}

class FoldableDirectoryTree extends StatelessWidget {
  final String rootPath;
  final void Function(File)? onFileTap;
  final dynamic folderClosedicon;
  final dynamic folderOpenedicon;
  final dynamic fileIcon;
  final TextStyle folderNameStyle;
  final TextStyle fileNameStyle;
  final Widget Function(String fileExtension)? fileIconBuilder;

  const FoldableDirectoryTree(
      {super.key,
      required this.rootPath,
      this.onFileTap,
      required this.folderClosedicon,
      required this.folderOpenedicon,
      required this.fileIcon,
      required this.folderNameStyle,
      required this.fileNameStyle,
      this.fileIconBuilder,
      });

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
  
  Widget _buildFileItem(File file) {
    final extension = path.extension(file.path).toLowerCase();
    final customIcon = fileIconBuilder != null? fileIconBuilder!(extension): fileIcon;
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
