class Synsets {
  final String languageCode;
  final String vocabularyId;
  final String concept;
  final String gloss;
  final String lemma;

  Synsets({this.languageCode, this.vocabularyId, this.concept, this.gloss, this.lemma});

  factory Synsets.fromJson(Map<String, dynamic> parsedJson){
    print(parsedJson);
    return Synsets(
      languageCode: parsedJson['languageCode'],
      vocabularyId: parsedJson['vocabularyId'].toString(),
      concept: parsedJson['concept'],
      gloss: parsedJson['gloss'],
      lemma: parsedJson['lemma'],

    );
  }
}

class Task {

  final String taskType;
  final String id;
  final String conceptId;
  final List<Synsets> synset;
  final String posTag;
  final String parentConceptId;
  final String parentConceptGlobalId;
  final String domainId;
  final String createdAt;
  final String updatedAt;
  final String v;


  Task({this.taskType, this.id, this.posTag, this.conceptId, this.synset, this.parentConceptId, this.parentConceptGlobalId, this.domainId, this.updatedAt, this.createdAt, this.v});

  factory Task.fromJson(Map<String, dynamic> json) {
    var list = json['synset'] as List;
    List<Synsets> synsetList = list.map((i) => Synsets.fromJson(i)).toList();

    List<String> _languageCodes = synsetList.map((x) {
      return x.languageCode.toString();
    }).toList();

    return new Task(
      id: json['_id'],
      posTag: json['posTag'],
      conceptId: json['conceptId'].toString(),
      synset: synsetList,
      parentConceptId: json['globalId'].toString(),
      parentConceptGlobalId: json['available'].toString(),
      domainId: json['domainId'],
      updatedAt: json['updatedAt'].toString(),
      createdAt: json['createdAt'].toString(),
      v: json['__v'].toString(),
    );
  }
}

class Words{
  final String statusCode;
  final List<Task> task;

  Words(this.statusCode, this.task);

//  factory Words.fromJson(Map<String, dynamic> parsJson){
//    print(parsJson);
//    return Words(
//      statusCode: parsJson['statusCode'],
//      lemma: parsJson['lemma'],
//    );
//  }

}

