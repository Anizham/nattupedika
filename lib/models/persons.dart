class Person {
  const Person(
    this.name,
    this.uid,
  );
  
  final String name;
  final String uid;
  
  Map<String, dynamic> toMap(){
    return {'name': name, 'uid': uid};
  }
  
  bool operator ==(other) => other is Person && other.name == name && other.uid == uid;
  // int get hashCode => hash2(name.hashCode, age.hashCode);
  int get hashCode => name.hashCode^uid.hashCode;
}