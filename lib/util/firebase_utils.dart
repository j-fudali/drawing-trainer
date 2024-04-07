import 'dart:convert';

class FirebaseUtils{
  FirebaseUtils();

  static Map<String, dynamic> getJsonFromOutput(String output){
    var response = output;
    if(output.startsWith(' ```json')){
      response = output.substring(8, output.length - 3);
    }
    else if (output.startsWith(' ``` JSON')){
      response = output.substring(9, output.length - 3);
    }
    return jsonDecode(response) as Map<String, dynamic>;
  }
}