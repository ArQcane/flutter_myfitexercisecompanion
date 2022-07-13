
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/data/models/user_detail.dart';

class ProfileImage extends StatelessWidget {
  double width;
  AsyncSnapshot<UserDetail?> snapshot;
  void Function()? onTap;
  ProfileImage({
    required this.width,
    required this.snapshot,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        shape: CircleBorder(),
        shadows: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2,
          ),
        ],
      ),
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            child: Container(
              width: width,
              height: width,
              alignment: Alignment.center,
              child: _checkLoading(
                context,
                snapshot,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _checkLoading(
      BuildContext context,
      AsyncSnapshot<UserDetail?> snapshot,
      ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }

    if (snapshot.data?.profilePic == null) {
      return Icon(
        Icons.person,
        size: width,
        color: Colors.grey,
      );
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.network(
        snapshot.data!.profilePic!,
        fit: BoxFit.cover,
        loadingBuilder: _loadingBuilder,
      ),
    );
  }

  Widget _loadingBuilder(
      BuildContext context,
      Widget child,
      ImageChunkEvent? loadingProgress,
      ) {
    if (loadingProgress == null) return child;
    if (loadingProgress.expectedTotalBytes == null) {
      return const CircularProgressIndicator();
    }
    double percentLoaded = 1.0 *
        (loadingProgress.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!);
    return CircularProgressIndicator(
      value: percentLoaded,
    );
  }
}