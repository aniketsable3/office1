import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<dynamic> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  fetchNotes() async {
    final data = await ApiService.fetchNotes();
    setState(() {
      notes = data;
    });
  }

  addOrUpdateNote({
    int? sno,
    String title = '',
    String description = '',
    String sdate = '',
    String edate = '',
  }) async {
    final TextEditingController titleController = TextEditingController(text: title);
    final TextEditingController descriptionController = TextEditingController(text: description);
    final TextEditingController sdateController = TextEditingController(text: sdate);
    final TextEditingController edateController = TextEditingController(text: edate);

    Future<void> selectDate(TextEditingController controller) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null) {
        setState(() {
          controller.text = pickedDate.toString().split(' ')[0]; // format as yyyy-MM-dd
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(sno == null ? 'Add Note' : 'Edit Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: sdateController,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => selectDate(sdateController),
                    ),
                  ),
                  readOnly: true,
                ),
                TextField(
                  controller: edateController,
                  decoration: InputDecoration(
                    labelText: 'End Date',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => selectDate(edateController),
                    ),
                  ),
                  readOnly: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (sno == null) {
                  await ApiService.insertNote(
                    titleController.text,
                    descriptionController.text,
                    sdateController.text,
                    edateController.text,
                  );
                } else {
                  await ApiService.updateNote(
                    sno,
                    titleController.text,
                    descriptionController.text,
                    sdateController.text,
                    edateController.text,
                  );
                }
                fetchNotes();
                Navigator.of(context).pop();
              },
              child: Text(sno == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  deleteNoteConfirmation(int sno) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () async {
                await ApiService.deleteNote(sno);
                fetchNotes();
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add The Notes to iNotes'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchNotes,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            DateTime endDate = DateTime.parse(note['edate']);
            bool isExpired = endDate.isBefore(DateTime.now());

            return Card(
              color: isExpired ? Colors.red.shade100 : Colors.white,
              child: ListTile(
                title: Text(
                  note['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isExpired ? Colors.red : Colors.black,
                  ),
                ),
                subtitle: Text(
                  '${note['description']}\nStart: ${note['sdate']} End: ${note['edate']}',
                  style: TextStyle(
                    color: isExpired ? Colors.red : Colors.black,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => addOrUpdateNote(
                        sno: int.parse(note['sno']),
                        title: note['title'],
                        description: note['description'],
                        sdate: note['sdate'],
                        edate: note['edate'],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteNoteConfirmation(int.parse(note['sno'])),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addOrUpdateNote(),
        child: Icon(Icons.add),
        tooltip: 'Add Note',
      ),
    );
  }
}
