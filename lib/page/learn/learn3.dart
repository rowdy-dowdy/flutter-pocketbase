import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// person
@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  Person({
    required this.name,
    required this.age,
    String? uuid
  }) : uuid = uuid ?? const Uuid().v4();

  Person update([String? name, int? age]) => Person(
    name: name ?? this.name,
    age: age ?? this.age,
    uuid: uuid
  );

  String get displayName => '$name ($age years old)';

  // @override
  // List<Object> get props => [name, age, uuid];

  @override
  bool operator == (covariant Person other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() => 'Person(name: $name, age: $age, uuid: $uuid)';
}

class DataModel extends ChangeNotifier {
  final List<Person> _people = [];

  int get count => _people.length;

  UnmodifiableListView<Person> get people => UnmodifiableListView(_people);

  void add(Person person) {
    _people.add(person);
    notifyListeners();
  }

  void remove(Person person) {
    _people.remove(person);
    notifyListeners();
  }

  void update(Person person) {
    final index = _people.indexOf(person);
    final oldPerson = _people[index];

    if ( oldPerson.name != person.name
      || oldPerson.age != person.age ) {
      
      _people[index] = oldPerson.update(
        person.name,
        person.age,
      );
      notifyListeners();
    }
  }
}

final peopleProvider = ChangeNotifierProvider<DataModel>((ref) {
  return DataModel();
});

class Learn3Screen extends ConsumerWidget {
  const Learn3Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn 3'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          
          ],
        ),
      ),
    );
  }
}

final nameController = TextEditingController();
final ageController = TextEditingController();

Future<Person?> createOrUpdatePersonDialog(BuildContext context, [Person? exitingPerson]) {
  String? name = exitingPerson?.name;
  int? age = exitingPerson?.age;

  nameController.text = name ?? '';
  ageController.text = age?.toString() ?? '';

  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: const Text('Create a person'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Enter name here'
            ),
            onChanged: (value) => name = value,
          ),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(
              labelText: 'Enter name here'
            ),
            onChanged: (value) => age = int.tryParse(value),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (name != null && age != null) {
              if (exitingPerson != null) {
                final newPerson = exitingPerson.update(name, age);
                Navigator.of(context).pop();
              }
              else {

              }
            }
            else {
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        )
      ],
    );
  });
}