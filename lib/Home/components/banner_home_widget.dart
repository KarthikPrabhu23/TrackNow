import 'package:flutter/material.dart';
import 'package:map1/Home/components/circular_banner_image.dart';
import 'package:map1/my_colors.dart';

class BannerHomeWidget extends StatelessWidget {
  const BannerHomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.24,
      decoration: BoxDecoration(
        color: Colors.black12,
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
              'https://firebasestorage.googleapis.com/v0/b/map1-6175b.appspot.com/o/bg1.png?alt=media&token=f98fb95f-bcd0-45cf-b344-78d82489390a'),
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Color(0x250F1113),
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0x430F1113),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12, 20, 12, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 70, 0),
                child: Text(
                  'Navigate with precision and ease.',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 17,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                child: Text(
                  'Active users',
                  style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircularBannerImage(
                      imageUrl: MyColors.man1,
                    ),
                    CircularBannerImage(
                      imageUrl: MyColors.man2,
                    ),
                    CircularBannerImage(
                      imageUrl: MyColors.man3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
