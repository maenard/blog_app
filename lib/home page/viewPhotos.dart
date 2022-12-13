import 'package:flutter/material.dart';

class ViewPhotos extends StatelessWidget {
  const ViewPhotos({
    super.key,
    required this.img,
  });

  final String img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(39, 158, 158, 158),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              img,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
