
class Note{

  int id;
  String title;
  String description;
  String date;

  Note(this.title, this.description, this.date);

  Note.fromMap(Map map){

    this.id = map["id"];
    this.title = map["title"];
    this.description = map["description"];
    this.date = map["date"];

  }

  Map toMap(){

    Map<String, dynamic> map = {
      "title" : this.title,
      "description" : this.description,
      "date" : this.date,
    };

    if( this.id != null ){
      map["id"] = this.id;
    }

    return map;

  }

}