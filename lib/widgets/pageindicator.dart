import 'package:flutter/material.dart';

class PageindIcator extends StatelessWidget {
  PageindIcator(
      {super.key,
      required this.btntitle,
      required this.currpage,
      required this.navfun});
  Function navfun;
  String btntitle;
  int currpage;
  double indicatorheight = 3;
  
  @override
  Widget build(BuildContext context) {
    if (currpage != 0 && btntitle == "Pending Task") {
      indicatorheight = 0;
    }
    if (currpage != 1 && btntitle == "Completed Task") {
      indicatorheight = 0;
    }
    return Column(
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: const Color.fromARGB(126, 38, 61, 68),
            ),
            onPressed: () {
              if(currpage == 0 && btntitle == "Completed Task"){
                navfun(1);
              }else if(currpage == 1 && btntitle == "Pending Task"){
                navfun(0);
              }
              
            },
            child: Text(btntitle)),
        const SizedBox(
          height: 1,
        ),
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          height: indicatorheight,
          width: 30,
        )
      ],
    );
  }
}
