import 'package:file_tree_view/file_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:file_icon/file_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart'; 

void main() {
  runApp(
    const MaterialApp(
      home: kIsWeb?Scaffold(body: Center(child: Text("Web not supported"),),): Home()
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
              rootPath: '/home/athul/Projects/AndroidApps/apps/survey_app', //Adjust the root folder path to desired folder
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

