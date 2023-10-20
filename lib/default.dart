import 'package:demodb/DB.dart/SqlHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class defaultscreen extends StatefulWidget {
  const defaultscreen({super.key});

  @override
  State<defaultscreen> createState() => _defaultStatescreen();
}

class _defaultStatescreen extends State<defaultscreen> {
  List<Map<String, dynamic>> journels = [];
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();
  bool check = false;
  int status = 0;
  bool isloading = true;
  void refreshJournel() async {
    final data = await SqlHelper.getItems();
    setState(() {
      journels = data;
      isloading = false;
    });
    print("total items are ${journels}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshJournel();
  }

  void additem() {
    SqlHelper.createItem(titlecontroller.text, desccontroller.text);
    refreshJournel();
  }

  void updateitem(int id, int? status) {
    SqlHelper.updateItem(id, titlecontroller.text, desccontroller.text, status);
    refreshJournel();
  }

  void updatestatus(int id, String title, String desc, int status) {
    SqlHelper.updateItem(id, title, desc, status);
    refreshJournel();
  }

  void showform(int? id, int? status) async {
    if (id != null) {
      final existingJournal =
          journels.firstWhere((element) => element['Id'] == id);
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
                child: Text(id == null ? "Add To-do" : "Update To-do",
                    style: GoogleFonts.roboto(
                        fontSize: 25,
                        color: const Color.fromARGB(199, 29, 20, 0),
                        fontWeight: FontWeight.w500)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                width: 300,
                height: 50,
                child: TextField(
                  style: const TextStyle(
                      color: Color.fromARGB(179, 24, 17, 2), fontSize: 20),
                  controller: titlecontroller,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                      labelText: "Title",
                      focusColor: Colors.white,
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      floatingLabelStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 24,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      filled: true,
                      fillColor: Color.fromARGB(58, 255, 255, 255)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                width: 300,
                height: 50,
                child: TextField(
                  style: const TextStyle(
                      color: Color.fromARGB(179, 24, 17, 2), fontSize: 20),
                  controller: desccontroller,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                      labelText: "Description",
                      focusColor: Colors.white,
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      floatingLabelStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 24,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      filled: true,
                      fillColor: Color.fromARGB(58, 255, 255, 255)),
                ),
              ),
              const SizedBox(
                height: 10,
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
            title: Center(
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
              : ListView.builder(
                  itemCount: journels.length,
                  itemBuilder: (context, index) => Card(
                    elevation: 1,
                    shadowColor: Color.fromARGB(183, 66, 70, 71),
                    margin: EdgeInsets.all(10),
                    color: Color.fromARGB(108, 36, 58, 66),
                    child: ListTile(
                      leading: SizedBox(
                        width: 20,
                        child: Checkbox(
                          
                          checkColor: Color.fromARGB(255, 2, 255, 65),
                          fillColor: const MaterialStatePropertyAll(
                            Color.fromARGB(108, 142, 163, 172),
                          ),
                          shape: const ContinuousRectangleBorder(),
                          value: journels[index]['status'] == 0 ? false : true,
                          onChanged: (value) {
                            if (journels[index]['status'] == 0) {
                              updatestatus(
                                  journels[index]['Id'],
                                  journels[index]['title'],
                                  journels[index]['description'],
                                  1);
                            } else {
                              updatestatus(
                                  journels[index]['Id'],
                                  journels[index]['title'],
                                  journels[index]['description'],
                                  0);
                            }
                          },
                        ),
                      ),
                      title: Text(journels[index]['title'],
                          style: const TextStyle(
                              color: Color.fromARGB(255, 121, 96, 7),
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                      subtitle: Text(journels[index]['description'],
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 156, 170),
                              fontSize: 17,
                              overflow: TextOverflow.ellipsis)),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  showform(journels[index]['Id'],
                                      journels[index]['status']);
                                },
                                icon: const Icon(
                                  Icons.edit_document,
                                  color: Color.fromARGB(255, 88, 71, 8),
                                )),
                            IconButton(
                                onPressed: () {
                                  SqlHelper.deleteItem(journels[index]['Id']);
                                  refreshJournel();
                                },
                                icon: const Icon(
                                  Icons.delete_sweep,
                                  color: Color.fromARGB(255, 88, 71, 8),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
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
