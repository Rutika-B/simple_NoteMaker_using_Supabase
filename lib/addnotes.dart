import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class addnotes extends StatefulWidget {
  const addnotes({super.key});

  @override
  State<addnotes> createState() => _addnotesState();
}

class _addnotesState extends State<addnotes> {
  final liststream =
      Supabase.instance.client.from('notes').stream(primaryKey: ['id']);
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyNotes app"),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: liststream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 81, 163, 174),
              ),
            );
          }
          final notes = snapshot.data!;
          return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(5),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(9),
                    tileColor: Color.fromARGB(255, 162, 219, 227),
                    title: (Text(
                      "${notes[index]['body']}",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    )),
                    trailing: IconButton(
                      onPressed: () async {
                        await Supabase.instance.client
                            .from('notes')
                            .delete()
                            .eq('id', notes[index]['id']);
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Color.fromARGB(255, 7, 3, 76),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: ((context) {
              return SimpleDialog(
                title: Text("Add note"),
                contentPadding: EdgeInsets.all(8),
                children: [
                  TextFormField(
                    controller: _controller,
                    onFieldSubmitted: (value) async {
                      await Supabase.instance.client
                          .from('notes')
                          .insert({'body': value});
                    },
                  ),
                ],
              );
            }),
          );
        },
      ),
    );
    ;
  }
}
