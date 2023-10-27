import 'package:demodb/DB.dart/SqlHelper.dart';
import 'package:flutter/material.dart';

class CompletedTask extends StatefulWidget {
  CompletedTask({super.key, required this.updatestatus,required this.filter,});
  Function updatestatus;
  String filter;
  @override
  State<CompletedTask> createState() => _CompletedTaskState();
}

class _CompletedTaskState extends State<CompletedTask> {
  List<Map<String, dynamic>> completedtask = [];
  bool isloading = true;
  void refreshJournel() async {
    var data;
    if (widget.filter == 'Show All') {
      data = await SqlHelper.getpendingItems(1);
    } else {
      data = await SqlHelper.filterGetPendingItems(1, widget.filter);
    }

    setState(() {
      completedtask = data;
      isloading = false;
      //print("checking filter" + widget.filter);
    });
    print("total items are pending task${completedtask}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshJournel();
  }

  Widget build(BuildContext context) {
    return isloading == true
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ))
        : completedtask.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 50, left: 10),
                      child: Opacity(
                          opacity: 0.3,
                          child: Image.asset(
                            "assets/sadface.png",
                            color: Colors.white,
                          ))),
                  const Center(
                    child: Text(
                      "No Task Completed :(",
                      style: TextStyle(
                          color: Color.fromARGB(209, 197, 197, 197),
                          fontSize: 18),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: completedtask.length,
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
                          backgroundColor: const Color.fromARGB(255, 4, 47, 58),
                          actions: [
                            TextButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(160, 37, 79, 90),
                                )),
                                onPressed: () {
                                  SqlHelper.deleteItem(
                                      completedtask[index]['Id']);
                                  refreshJournel();
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 20, 121, 36)),
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
                                      color: Color.fromARGB(255, 197, 45, 19)),
                                )),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
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
                            value: completedtask[index]['status'] == 0
                                ? false
                                : true,
                            onChanged: (value) {
                              widget.updatestatus(
                                  completedtask[index]['Id'],
                                  completedtask[index]['title'],
                                  completedtask[index]['description'],
                                  0,completedtask[index]['category'],);
                              refreshJournel();
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor:
                                    const Color.fromARGB(108, 142, 163, 172),
                                content: Text(
                                    "${completedtask[index]['title']} task status changed to pending",
                                    style: const TextStyle(fontSize: 15)),
                              ));
                            }
                            //},
                            ),
                      ),
                      title: Text(completedtask[index]['title'],
                          style: const TextStyle(
                              color: Color.fromARGB(255, 214, 214, 214),
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(completedtask[index]['description'],
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 156, 170),
                                  fontSize: 17,
                                  overflow: TextOverflow.ellipsis)),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                              "Created on: ${completedtask[index]['createdAt'].toString().substring(0, 10)}",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 110, 110, 110),
                                fontSize: 14,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }
}
