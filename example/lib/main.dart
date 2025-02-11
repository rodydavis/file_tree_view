import 'package:file/memory.dart';
import 'package:file_tree_view/file_tree_view.dart';
import 'package:file_tree_view/style.dart';
import 'package:flutter/material.dart';
import 'package:file_icon/file_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() async {
  runApp(MaterialApp(home: Home(), theme: ThemeData.dark(), debugShowCheckedModeBanner: false));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final fs = MemoryFileSystem();
  late final root = fs.directory('.');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var i = 0; i < 10; i++) {
        final file = fs.file('${root.path}/$i.md');
        file.createSync(recursive: true);
        file.writeAsStringSync('File: $i');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181818),
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.grey)),
      drawer: Drawer(
        backgroundColor: const Color(0xff2b2b2b),
        child: SingleChildScrollView(
          child: SizedBox(
            child: DirectoryTreeViewer(
              fs: fs,
              rootPath: root.path,
              enableCreateFileOption: true,
              enableCreateFolderOption: true,
              editingFieldStyle: EditingFieldStyle(
                textStyle: const TextStyle(color: Colors.grey),
                cursorColor: Colors.grey,
                cursorHeight: 18,
                verticalTextAlign: TextAlignVertical.top,
                textfieldDecoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                folderIcon: const Icon(Icons.folder, color: Colors.grey, size: 20),
                fileIcon: const Icon(Icons.edit_document, color: Colors.grey, size: 20),
                doneIcon: const Icon(Icons.check, color: Colors.grey, size: 20),
                cancelIcon: const Icon(Icons.close, color: Colors.grey, size: 20),
              ),
              folderStyle: FolderStyle(
                folderNameStyle: TextStyle(color: Colors.grey[400]),
                folderClosedicon: SvgPicture.asset('assets/icons/folder.svg', height: 25, width: 25),
                folderOpenedicon: SvgPicture.asset('assets/icons/open-file-folder.svg', height: 25, width: 25),
                iconForCreateFile: const Icon(FontAwesomeIcons.fileCirclePlus, color: Colors.grey, size: 14),
                iconForCreateFolder: const Icon(Icons.create_new_folder, color: Colors.grey, size: 17),
              ),
              fileStyle: FileStyle(fileNameStyle: TextStyle(color: Colors.grey[400])),
              fileIconBuilder: (extension) => FileIcon(extension),
            ),
          ),
        ),
      ),
      body: const Center(child: Text("Example with custom icons", style: TextStyle(color: Colors.grey))),
    );
  }
}
