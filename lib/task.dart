import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(TaskApp());
}

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.orange),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyText2: TextStyle(fontSize: 16.0, color: Colors.black87),
          subtitle1: TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: TaskScreen(),
    );
  }
}

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<dynamic> notes = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  fetchNotes() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/office1/task.php'));
      if (response.statusCode == 200) {
        setState(() {
          notes = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load notes');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching notes: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchNotes,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchNotes,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : notes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.note, size: 80, color: Colors.grey),
                          SizedBox(height: 10),
                          Text('No notes available', style: TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        DateTime endDate = DateTime.parse(note['edate']);
                        bool isExpired = endDate.isBefore(DateTime.now());

                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 4.0,
                          margin: EdgeInsets.symmetric(vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isExpired
                                    ? [Colors.red[100]!, Colors.red[200]!]
                                    : [Colors.blue[50]!, Colors.blue[100]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.0),
                              leading: Icon(
                                isExpired ? Icons.warning : Icons.note,
                                color: isExpired ? Colors.red : Colors.blue,
                              ),
                              title: Text(
                                note['title'],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text(note['description']),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                                      SizedBox(width: 4),
                                      Text(
                                        'Start: ${note['sdate']}',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      SizedBox(width: 16),
                                      Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                                      SizedBox(width: 4),
                                      Text(
                                        'End: ${note['edate']}',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
