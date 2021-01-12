import 'package:my_notes/model/Note.dart';
import 'package:my_notes/helper/NoteHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _db = NoteHelper();
  List<Note> _notes = List<Note>();


  _showScreenRegister( {Note note} ){

    String textSaveUpdate = "";
    if( note == null ){//save
      _titleController.text = "";
      _descriptionController.text = "";
      textSaveUpdate = "Save";
    }else{ // update
      _titleController.text = note.title;
      _descriptionController.text = note.description;
      textSaveUpdate = "Update";
    }

    showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text("$textSaveUpdate a note"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "Type here..."
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: "Description",
                      hintText: "Type here..."
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel")
              ),
              FlatButton(
                  onPressed: (){
                    //salvar
                    _saveUpdateNote(noteSelected: note);
                    Navigator.pop(context);
                  },
                  child: Text(textSaveUpdate)
              )
            ],
          );
      }
    );
  }

  _getNotes() async {

    List notes = await _db.getNotes();
    List<Note> list = List<Note>();
    for( var item in notes ){
      Note notes = Note.fromMap( item );
      list.add( notes );
    }
    setState(() {
      _notes = list;
    });
    list = null;

  }


  _saveUpdateNote( {Note noteSelected} ) async {

    String title = _titleController.text;
    String description = _descriptionController.text;

    if( noteSelected == null ) {
      Note note = Note(title, description, DateTime.now().toString() );
      int result = await _db.saveNote( note );
    } else {
      noteSelected.title = title;
      noteSelected.description = description;
      noteSelected.date = DateTime.now().toString();
      int result = await _db.updateNote( noteSelected );
    }
    _titleController.clear();
    _descriptionController.clear();

    _getNotes();
  }

  _dateFormat(String date){

    initializeDateFormatting("pt_BR", null);

    //Year -> y month-> M Day -> d
    // Hour -> H minute -> m second -> s
    //var formatter = DateFormat("d/MMMM/y H:m:s");
    var formatter = DateFormat.yMd("pt_BR");

    DateTime dataConvert = DateTime.parse( date );
    String dateFormatted = formatter.format( dataConvert );

    return dateFormatted;


  }

  _removeNote( int id ) async {
    await _db.removeNote( id );
    _getNotes();

  }

  @override
  void initState() {
    super.initState();
    _getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My notes"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
                itemBuilder: (context, index) {

                final note = _notes[index];
                return Card(
                  child: ListTile(
                    title: Text( note.title ),
                    subtitle: Text("${ _dateFormat(note.date) } - ${ note.description }"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: (){

                            _showScreenRegister(note: note);

                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){

                            showAlertDialog(BuildContext context) {

                              // set up the buttons
                              Widget cancelButton = FlatButton(
                                child: Text("Cancel"),
                                onPressed:  () => Navigator.pop(context),
                              );
                              Widget continueButton = FlatButton(
                                child: Text("Continue"),
                                onPressed:  () {
                                  _removeNote( note.id );
                                  Navigator.pop(context);
                                },
                              );

                              // set up the AlertDialog
                              AlertDialog alert = AlertDialog(
                                title: Text("AlertDialog"),
                                content: Text("Would you really like to remove?"),
                                actions: [
                                  cancelButton,
                                  continueButton,
                                ],
                              );

                              // show the dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );

                            }
                            return showAlertDialog(context);

                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: (){
            _showScreenRegister();
          }
      ),
    );
  }
}
