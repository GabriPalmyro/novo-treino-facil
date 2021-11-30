import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class HeaderDrawer extends StatelessWidget {
  final String fullName;
  final String photoURL;
  final bool isPersonal;
  final Function onTap;

  const HeaderDrawer({
    this.fullName,
    this.photoURL,
    this.isPersonal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: new BoxDecoration(
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
                      return Center(child: CircularProgressIndicator());
                    }),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                fullName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: AppFonts.gotham,
                    color: AppColors.white,
                    fontSize: 17,
                    letterSpacing: 3),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                isPersonal ? "Personal Trainer" : "Aluno",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: AppFonts.gothamBook,
                    color: AppColors.white,
                    fontSize: 13,
                    letterSpacing: 2),
              ),
              Divider(
                color: AppColors.black.withOpacity(0.4),
                thickness: 0.8,
              )
            ],
          ),
        ));
  }
}
