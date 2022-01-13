import 'package:flutter/material.dart';
//es importante agregar esta dependencia en pubspec.yaml
import 'package:english_words/english_words.dart';

void main() {
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  //este es un widget y todo lo de adentro también son widgets
  Widget build(BuildContext context) {

    return  MaterialApp(
        title: 'Startup Name Generator',
        home: RandomWords(),
    );
  }
}

//stateful widget que recordara un estado,es decir tendra memoria de las sugerencias ya antes vistas
//escribes stateful tienes un snippet o shortcut para crear un statefulwidget y su extension
class RandomWords extends StatefulWidget {
  @override
  //aqui se esta llamando al build de _RandomWordsState y se crea un estado
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {

  //final es como global segun yo
  //vas a tener una lista de WordPairs y el estilo de la lista que podras acceder desde donde quieras
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {

    //ListView es un widget para cosntruir una lista
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        //itemBuilder es un widget que existira para cada fila "i" de la lista
        itemBuilder: /*1*/ (context, i) {
          //todo esto es para marcar una division entre cada fila visualmente

          //si el index i es impar se pone un divider, un elemnto visual que separa
          if (i.isOdd) return const Divider(); /*2*/

          //si el index i es par se
          final index = i ~/ 2; /*3*/

          //si llegaste al final de la lista se generaran 10 rows mas
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          //regresara cada row de la lista
          return _buildRow(_suggestions[index]);
        });
  }

  //crea las rows
  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        //se llama al estilo global creado antes
        style: _biggerFont,
      ),
    );
  }

  @override
  //build siempre regresare el widget completo, por lo que aqui puedes llamar a las funciones que lo armaran
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Startup Name Generator'),
      ),
      //en el body ira el widget que crea la lsita
      body: _buildSuggestions(),
    );
  }




  //los metodos que quieras llamar en build siempre iran abajo de esta funcion y dentro de la clase
}
