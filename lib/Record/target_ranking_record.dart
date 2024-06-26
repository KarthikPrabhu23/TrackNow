import 'package:flutter/material.dart';
import 'package:map1/Map/classes.dart';
import 'package:map1/Record/components/task_ranking_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TargetRankingRecord extends StatelessWidget {
  const TargetRankingRecord({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    // Initialize ScreenUtil
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812), 
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Column(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          scrollDirection: Axis.vertical,
          child: SizedBox(
            // height: MediaQuery.of(context).size.height * 0.55,
            // width:  MediaQuery.of(context).size.width,
            height: 0.54.sh,
            width: 1.sw,
            child: StreamBuilder<List<User>>(
              stream: FirestoreService.userCollectionStream(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (userSnapshot.hasError) {
                  return Text('Error: ${userSnapshot.error}');
                } else {
                  userSnapshot.data!.sort((a, b) => (b.targetCompletionCount ?? 0)
                      .compareTo(a.targetCompletionCount ?? 0));
        
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(9),
                    itemCount: userSnapshot.data!.length,
                    itemBuilder: (context, index) {
                      final userItem = userSnapshot.data![index];
        
                      return TaskRankingCard(
                        userItem: userItem,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
