import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class CardFriend extends StatelessWidget {
  final String nickname;
  final String name;
  final String photoURL;
  final Function onTap;

  const CardFriend(
      {@required this.nickname,
      @required this.name,
      @required this.photoURL,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 15,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 60,
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
                      child: Image.network(photoURL, fit: BoxFit.fitWidth,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(),
                        ));
                      }),
                    ),
                  ),
                ),
                Expanded(
                  flex: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '@$nickname',
                          style: TextStyle(
                              fontFamily: AppFonts.gothamLight,
                              color: AppColors.white,
                              fontSize: 14.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: AutoSizeText('$name',
                              maxLines: 1,
                              style: TextStyle(
                                  fontFamily: AppFonts.gotham,
                                  color: AppColors.white,
                                  fontSize: 24.0)),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: IconButton(
                      onPressed: onTap,
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: AppColors.white,
                      )),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Divider(
                color: AppColors.white,
                thickness: 0.8,
              ),
            )
          ],
        ),
      ),
    );
  }
}
