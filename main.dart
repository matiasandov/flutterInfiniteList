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
  //este es un set global para guardar las favoritas
  final _saved = <WordPair>{};

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
    //bool para checar que el pair  de la row ya este gurdado en favoritos o no
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        //se llama al estilo global creado antes
        style: _biggerFont,
      ),
      //Icono de corazon
      trailing: Icon(     // NEW from here...

        alreadySaved ? Icons.favorite : Icons.favorite_border,
        //si alreeadySaved es true lo pone en rojo, sino vacio
        color: alreadySaved ? Colors.red : null,
        //supongo que es un mensaje de consola
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),

      //metodo para anadir
      onTap: () {      // NEW lines from here...
        setState(() {
          //se ya estaba guardada y lo vuelves a dar tap, la borrara
          if (alreadySaved) {
            _saved.remove(pair);
            //si no estaba guardada, la guarda
          } else {
            _saved.add(pair);
          }
        });
      },               // ... to here.
    );
  }

  //este metodo hara push (agregar) a la ruta a la que se quiere ir al stack de navegacion del obejto navigator
  void _pushSaved() {
    Navigator.of(context).push(
      //widget de builder para abrir nueva pagina al hacer push al stack de navegacion
      MaterialPageRoute<void>(
        builder: (context) {

          //creara lista de tiles con cada elemento de la lista de _saved, que guarda las sugerencias
          //con map, para cada elemento define su texto y estilo
          final tiles = _saved.map(
                (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );

          //aqui se guardara la lsita creada arriba pero con divisiones, la cual sera cargda en el body
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
              : <Widget>[];

          //estructura de la pagina
          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  //build siempre regresare el widget completo, por lo que aqui puedes llamar a las funciones que lo armaran
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Startup Name Generator'),

        //acciones de interacion con la AppBar
        actions: [
          // Icono para abrir lista de pestanas
          IconButton(
            icon: const Icon(Icons.list),
            //al presionarse llamara a este metodo
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],

      ),
      //en el body ira el widget que crea la lsita
      body: _buildSuggestions(),
    );
  }




//los metodos que quieras llamar en build siempre iran abajo de esta funcion y dentro de la clase
}
