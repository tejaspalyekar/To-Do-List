import 'package:demodb/DB.dart/SqlHelper.dart';
import 'package:demodb/widgets/completedtask.dart';
import 'package:demodb/widgets/pageindicator.dart';
import 'package:demodb/widgets/pendingtask.dart';
import 'package:demodb/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class defaultscreen extends StatefulWidget {
  const defaultscreen({
    super.key,
  });

  @override
  State<defaultscreen> createState() => _defaultStatescreen();
}

class _defaultStatescreen extends State<defaultscreen> {
  int currpage = 0;
  String selectedvalue = "Other";
  String selectedfilter = "Show All";

  PageController pagecontoller = PageController();
  List<Map<String, dynamic>> pendingtask = [];
  List<Map<String, dynamic>> completedtask = [];
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();

  List<DropdownMenuItem<String>> filteritem = [
    const DropdownMenuItem(
      value: "Work",
      child: Text("work",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 15)),
    ),
    const DropdownMenuItem(
      value: "Home",
      child: Text("Home", style: TextStyle(color: Colors.white, fontSize: 15)),
    ),
    const DropdownMenuItem(
      value: "Other",
      child: Text("Other", style: TextStyle(color: Colors.white, fontSize: 15)),
    ),
    const DropdownMenuItem(
      value: "Show All",
      child: Text(
        "Show All",
        style:
            TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 15),
      ),
    ),
  ];
  List<DropdownMenuItem<String>> dropdownitems = [
    const DropdownMenuItem(
      value: "Work",
      child: Text("Work",
          style:
              TextStyle(color: Color.fromARGB(179, 24, 17, 2), fontSize: 15)),
    ),
    const DropdownMenuItem(
      value: "Home",
      child: Text("Home",
          style:
              TextStyle(color: Color.fromARGB(179, 24, 17, 2), fontSize: 15)),
    ),
    const DropdownMenuItem(
      value: "Other",
      child: Text("Other",
          style:
              TextStyle(color: Color.fromARGB(179, 24, 17, 2), fontSize: 15)),
    ),
  ];

  bool check = false;
  int status = 0;
  bool isloading = true;
  bool refresh = false;

  void refreshJournel() async {
    final data = await SqlHelper.getpendingItems(0);
    final data1 = await SqlHelper.getcompleteditem(1);
    List<Map<String, dynamic>> task = await SqlHelper.getItems();
    print(task);
    print("total items");
    setState(() {
      pendingtask = data;
      completedtask = data1;
      isloading = false;

      refresh = true;
    });

    print("total items are default screen${pendingtask}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshJournel();
  }

  void additem() {
    SqlHelper.createItem(
        titlecontroller.text, desccontroller.text, selectedvalue);
    refreshJournel();
    pagecontoller.animateToPage(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    setState(() {
      currpage = 0;
    });
  }

  void updateitem(int id, int? status) {
    SqlHelper.updateItem(
        id, titlecontroller.text, desccontroller.text, status, selectedvalue);
    refreshJournel();
  }

  void updatestatus(
      int id, String title, String desc, int status, String selectedvalue1) {
    SqlHelper.updateItem(id, title, desc, status, selectedvalue1);
    refreshJournel();
  }

  void showform(int? id, int? status) async {
    if (id != null) {
      final existingJournal =
          pendingtask.firstWhere((element) => element['Id'] == id);
      titlecontroller.text = existingJournal['title'];
      desccontroller.text = existingJournal['description'];
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: 650,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          color: const Color.fromARGB(216, 59, 48, 2),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(id == null ? "Add Task" : "Update Task",
                    style: GoogleFonts.roboto(
                        fontSize: 25,
                        color: const Color.fromARGB(199, 29, 20, 0),
                        fontWeight: FontWeight.w500)),
              ),
              const SizedBox(
                height: 10,
              ),
              ReuseableTextField(lable: "Title", controller: titlecontroller),
              ReuseableTextField(
                  lable: "Description", controller: desccontroller),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(58, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: DropdownButton(
                        underline: const Text(""),
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset("assets/dropdown.png",
                              color: const Color.fromARGB(207, 8, 57, 63)),
                        ),
                        value: selectedvalue,
                        borderRadius: BorderRadius.circular(20),
                        dropdownColor: const Color.fromARGB(213, 161, 153, 118),
                        items: dropdownitems,
                        onChanged: (String? value) {
                          if (value != selectedvalue) {
                            setState(() {
                              selectedvalue = value!;
                              print(value);
                            });
                            Navigator.of(context).pop();
                            showform(null, null);
                          }
                        }),
                  ),
                  const SizedBox(),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.date_range,size: 20,color: const Color.fromARGB(199, 29, 20, 0),),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(58, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(20)),
                              width: 100,
                              height: 40,
                              child: const Center(child: Text("Select Date")),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.more_time,size: 20,color: const Color.fromARGB(199, 29, 20, 0),),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(58, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(20)),
                              width: 100,
                              height: 40,
                              child: const Center(child: Text("Select Time")),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              CircleAvatar(
                minRadius: 20,
                backgroundColor: const Color.fromARGB(202, 1, 47, 53),
                child: Center(
                  child: IconButton(
                      onPressed: () {
                        if (titlecontroller.text == "" ||
                            desccontroller.text == "") {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("fields cannot be empty",
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 194, 194, 194))),
                                backgroundColor:
                                    const Color.fromARGB(255, 4, 47, 58),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 194, 194, 194)),
                                      )),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        if (id == null) {
                          additem();
                        }
                        if (id != null) {
                          updateitem(id, status);
                        }
                        titlecontroller.text = "";
                        desccontroller.text = "";
                        Navigator.of(context).pop();
                      },
                      iconSize: 35,
                      icon: const Icon(
                        Icons.done_outline_rounded,
                        color: Color.fromARGB(197, 177, 246, 255),
                      )),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void onnavclick(int idx) {
    pagecontoller.animateToPage(idx,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    setState(() {
      currpage = idx;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(136, 17, 17, 17)),
          textTheme: const TextTheme(
              bodyMedium: TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 15, 53, 95))),
        ),
        home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 12, 21, 24),
          appBar: AppBar(
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                width: 95,
                child: DropdownButton(
                    style: TextStyle(),
                    underline: Text("-----------"),
                    icon: Padding(
                        padding: const EdgeInsets.only(
                          left: 7,
                        ),
                        child: Image.asset(
                          "assets/filter.png",
                          color: Colors.white,
                          height: 16,
                        )),
                    value: selectedfilter,
                    dropdownColor: const Color.fromARGB(179, 8, 57, 63),
                    items: filteritem,
                    onChanged: (String? value) {
                      if (value != selectedfilter) {
                        setState(() {
                          selectedfilter = value!;
                        });
                      }
                    }),
              )
            ],
            title: Padding(
                padding: EdgeInsets.only(left: 120),
                child: Text(
                  "To-Do List",
                  style: GoogleFonts.notoSerif(fontSize: 25),
                )),
          ),
          body: isloading == true
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))
              : Column(
                  children: [
                    Container(
                      height: 80,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PageindIcator(
                              navfun: (int a) {
                                onnavclick(a);
                              },
                              btntitle: "Pending Task",
                              currpage: currpage),
                          const SizedBox(
                            width: 10,
                          ),
                          PageindIcator(
                              navfun: (int b) {
                                onnavclick(b);
                              },
                              btntitle: "Completed Task",
                              currpage: currpage)
                        ],
                      ),
                    ),
                    Container(
                      height: 680,
                      child: PageView(
                        onPageChanged: (value) {
                          setState(() {
                            currpage = value;
                          });
                        },
                        controller: pagecontoller,
                        children: [
                          PendingTask(
                              filter: selectedfilter,
                              refresh: refresh,
                              showform: (int id, int status1) {
                                showform(id, status1);
                              },
                              updatestatus: (int id, String title, String desc,
                                  int status1, String category) {
                                updatestatus(
                                    id, title, desc, status1, category);
                              }),
                          CompletedTask(
                              filter: selectedfilter,
                              updatestatus: (int id, String title, String desc,
                                  int status, String category1) {
                                updatestatus(
                                    id, title, desc, status, category1);
                              })
                        ],
                      ),
                    )
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              refreshJournel();
              titlecontroller.text = "";
              desccontroller.text = "";
              showform(null, null);
            },
            splashColor: const Color.fromARGB(255, 53, 115, 134),
            backgroundColor: const Color.fromARGB(255, 88, 71, 8),
            child: const Icon(Icons.add_circle_outline_outlined),
          ),
        ));
  }
}
