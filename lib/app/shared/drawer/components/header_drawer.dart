import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/shared/shimmer/skeleton.dart';

class HeaderDrawer extends StatelessWidget {
  final String fullName;
  final String photoURL;
  final bool isPersonal;
  final VoidCallback onTap;

  const HeaderDrawer({
    required this.fullName,
    required this.photoURL,
    required this.isPersonal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 50.0, left: 12.0, right: 12.0),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (photoURL.isNotEmpty) ...[
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
                      child:
                          // CachedNetworkImage(
                          //     imageUrl: photoURL,
                          //     fit: BoxFit.fitWidth,
                          //     // progressIndicatorBuilder: (_, url, download) {
                          //     //   log(download.downloaded.toString());
                          //     //   log(url.toString());
                          //     //   return Center(child: CircularProgressIndicator());
                          //     // },
                          //     errorWidget: (context, url, error) =>
                          //         Text("$error"),
                          //     placeholder: (context, url) => Text("Loading $url"),
                          //     imageBuilder: (context, imageProvider) => Container(
                          //           width: double.infinity,
                          //           height: 150,
                          //           decoration: BoxDecoration(
                          //             image: DecorationImage(
                          //                 image: imageProvider,
                          //                 fit: BoxFit.fitWidth),
                          //           ),
                          //         ))
                          Image.network(
                        photoURL,
                        fit: BoxFit.fitWidth,
                        loadingBuilder: (_, __, ___) {
                          return Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Shimmer.fromColors(
                                baseColor: AppColors.lightGrey,
                                highlightColor: AppColors.grey300,
                                child: Skeleton(height: 100, width: 100),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(
                height: 20,
              ),
              Text(
                fullName,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: AppFonts.gotham, color: AppColors.white, fontSize: 17, letterSpacing: 3),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                isPersonal ? "Personal Trainer" : "Aluno",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: AppFonts.gothamBook, color: AppColors.white, fontSize: 13, letterSpacing: 2),
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
