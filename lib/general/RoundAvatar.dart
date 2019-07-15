import 'package:flutter/material.dart';

class RoundAvatar extends StatelessWidget {
  String avatarUrl;
  double height;
  bool isLocal;
  RoundAvatar(this.avatarUrl, this.height, this.isLocal);

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsetsDirectional.only(end: 8),
        height: height,
        width: height,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                image: isLocal ? new AssetImage(avatarUrl) : new NetworkImage(avatarUrl)
            )
        )
    );
  }
}