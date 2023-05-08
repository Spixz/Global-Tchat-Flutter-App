import 'package:rxdart/rxdart.dart';
// * RxDart extends the capabilities of Dart Streams and StreamControllers.

// * Le T correspond au type de la valeur qui sera utilisé dans le stream

// ! Cette class est un wrapper de BehaviorSubject
// An in-memory store backed by BehaviorSubject that can be used to
// store the data for all the fake repositories in the app.
class InMemoryStore<T> {
  //Donne a notre BehaviorSubject la valeur initial reçue en paramètre du constructeur
  InMemoryStore(T initial) : _subject = BehaviorSubject<T>.seeded(initial);

  final BehaviorSubject<T> _subject;

  /// The output stream that can be used to listen to the data
  Stream<T> get stream => _subject.stream;
  /// A synchronous getter for the current value
  T get value => _subject.value;
  /// A setter for updating the value
  set value(T value) => _subject.add(value); //Add au stream

  void close() => _subject.close();
}

//En gros cette classe permet de stocker stocker une variable et d'y permettre
//l'accès à toute l'app depuis un stream ou de manière synchrone avec les getter.
//C'est une abstraction d'une basse de donneé pour une variable quoi.
// * La classe pourra ensuite être modifié pour stocker des données de manière persistante.