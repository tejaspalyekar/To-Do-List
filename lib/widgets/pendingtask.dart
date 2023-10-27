import 'package:demodb/DB.dart/SqlHelper.dart';
import 'package:demodb/default.dart';
import 'package:flutter/material.dart';

class PendingTask extends StatefulWidget {
  PendingTask(
      {super.key,
      required this.filter,
      required this.updatestatus,
      required this.showform,
      this.refresh});
  bool? refresh;
  Function updatestatus;
  Function showform;
  String filter;

  @override
  State<PendingTask> createState() => PendingTaskState();
}

class PendingTaskState extends State<PendingTask> {
  List<Map<String, dynamic>> pendingtask = [];
  bool value = false;
  bool isloading = true;
  void refreshJournel() async {
    var data;
    if (widget.filter == 'Show All') {
      data = await SqlHelper.getpendingItems(0);
    } else {
      data = await SqlHelper.filterGetPendingItems(0, widget.filter);
    }



    setState(() {
      pendingtask = data;
      isloading = false;
      //print("checking filter" + widget.filter);
    });
    print("total items are pending task${pendingtask}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshJournel();
  }

  Widget build(BuildContext context) {
    if (widget.refresh == true) {
      print("____________________________________");
      refreshJournel();
      widget.refresh = false;
      print(widget.refresh);
    }
    return isloading == true
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ))
        : pendingtask.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 50, left: 50),
                      child: Opacity(
                          opacity: 0.3,
                          child: Image.asset("assets/addtask.png"))),
                  const Center(
                    child: Text(
                      "Hurray...Nothing to do",
                      style: TextStyle(
                          color: Color.fromARGB(209, 197, 197, 197),
                          fontSize: 18),
                    ),
                  ),
                ],
              )
            : Container(
                height: 500,
                child: ListView.builder(
                  itemCount: pendingtask.length,
                  itemBuilder: (context, index) => Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: const Color.fromARGB(150, 56, 16, 16),
                    ),
                    onDismissed: (direction) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Are you sure you want to delete",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 194, 194, 194))),
                            backgroundColor:
                                const Color.fromARGB(255, 4, 47, 58),
                            actions: [
                              TextButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(160, 37, 79, 90),
                                  )),
                                  onPressed: () {
                                    SqlHelper.deleteItem(
                                        pendingtask[index]['Id']);
                                    refreshJournel();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 20, 121, 36)),
                                  )),
                              TextButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(160, 37, 79, 90),
                                  )),
                                  onPressed: () {
                                    refreshJournel();
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 197, 45, 19)),
                                  )),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      elevation: 1,
                      shadowColor: const Color.fromARGB(183, 66, 70, 71),
                      margin: const EdgeInsets.all(10),
                      color: const Color.fromARGB(108, 36, 58, 66),
                      child: ListTile(
                        leading: SizedBox(
                          width: 20,
                          child: Checkbox(
                            checkColor: const Color.fromARGB(255, 2, 255, 65),
                            fillColor: const MaterialStatePropertyAll(
                              Color.fromARGB(108, 142, 163, 172),
                            ),
                            shape: const ContinuousRectangleBorder(),
                            value: pendingtask[index]['status'] == 0
                                ? false
                                : true,
                            onChanged: (value1) {
                              if (pendingtask[index]['status'] == 0) {
                                widget.updatestatus(
                                  pendingtask[index]['Id'],
                                  pendingtask[index]['title'],
                                  pendingtask[index]['description'],
                                  1,
                                  pendingtask[index]['category'],
                                );

                                refreshJournel();
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor:
                                      const Color.fromARGB(108, 105, 123, 131),
                                  content: Text(
                                      'Hurray... ${pendingtask[index]['title']} task completed',
                                      style: const TextStyle(fontSize: 15)),
                                ));
                              }
                            },
                          ),
                        ),
                        
                        title: Text(pendingtask[index]['title'],
                            style: const TextStyle(
                                color: Color.fromARGB(255, 214, 214, 214),
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pendingtask[index]['description'],
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 156, 170),
                                    fontSize: 17,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                                "Created on: ${pendingtask[index]['createdAt'].toString().substring(0, 10)}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 110, 110, 110),
                                  fontSize: 14,
                                ))
                          ],
                        ),
                        trailing: SizedBox(
                          width: 50,
                          child: Row(
                            children: [
                              IconButton(
                                  splashRadius: 20,
                                  onPressed: () {
                                    widget.showform(pendingtask[index]['Id'],
                                        pendingtask[index]['status']);
                                  },
                                  icon: const Icon(
                                    Icons.edit_document,
                                    color: Color.fromARGB(255, 126, 126, 126),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
  }
}
