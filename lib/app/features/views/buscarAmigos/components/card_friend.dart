import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class CardFriend extends StatelessWidget {
  final String nickname;
  final String name;
  final String photoURL;
  final VoidCallback onTap;

  const CardFriend(
      {required this.nickname,
      required this.name,
      required this.photoURL,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: photoURL,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  // Image.network(photoURL, fit: BoxFit.fitWidth,
                  //     loadingBuilder: (BuildContext context, Widget child,
                  //         ImageChunkEvent loadingProgress) {
                  //   if (loadingProgress == null) {
                  //     return child;
                  //   }
                  //   return Center(
                  //       child: Padding(
                  //     padding: const EdgeInsets.all(10.0),
                  //     child: CircularProgressIndicator(
                  //       strokeWidth: 2,
                  //     ),
                  //   ));
                  // }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@$nickname',
                    style: TextStyle(
                        fontFamily: AppFonts.gotham,
                        color: AppColors.white,
                        fontSize: 18.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: AutoSizeText('$name',
                        maxLines: 1,
                        style: TextStyle(
                            fontFamily: AppFonts.gothamBook,
                            color: AppColors.white,
                            fontSize: 16.0)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
