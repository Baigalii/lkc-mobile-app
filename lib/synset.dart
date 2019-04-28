class Tasks {

  final String statusCode;
  final List<Task> task;



  Tasks({this.statusCode, this.task});

  factory Tasks.fromJson(Map<String, dynamic> json) {
    var list = json['task'] as List;
    print(list.runtimeType);
    List<Task> tasksList = list.map((i) => Task.fromJson(i)).toList();

    return new Tasks(
      statusCode: json['statusCode'],
      task: tasksList,
    );
  }
}

class Task {
  final String taskType;
  final List<Synset> synset;
  final String id;
  final String conceptId;
  final String conceptGlobalId;
  final String posTag;
  final String parentConceptId;
  final String parentConceptGlobalId;
  final String domainId;
  final String createdAt;
  final String updatedAt;
  final String v;

  Task({this.taskType, this.synset, this.id, this.conceptId,  this.conceptGlobalId, this.posTag, this.parentConceptId, this.parentConceptGlobalId, this.domainId, this.createdAt, this.updatedAt, this.v });

  factory Task.fromJson(Map<String, dynamic> parsedJson){
    var list = parsedJson['synset'] as List;
    print(list.runtimeType);
    List<Synset> synsetList = list.map((i) => Synset.fromJson(i)).toList();
    print(parsedJson);
    return Task(
      taskType: parsedJson['taskType'],
      synset: synsetList,
      id: parsedJson['_id'],
      conceptId: parsedJson['conceptId'],
      conceptGlobalId: parsedJson['conceptGlobalId'],
      posTag: parsedJson['posTag'],
      parentConceptId: parsedJson['parentConceptId'],
      parentConceptGlobalId: parsedJson['parentConceptGlobalId'],
      domainId: parsedJson['domainId'],
      createdAt: parsedJson['createdAt'],
      updatedAt: parsedJson['updatedAt'],
    );
  }
}

class Synset {
  final String languageCode;
  final String vocabularyId;
  final String concept;
  final String gloss;
  final String lemma;

  Synset({this.languageCode, this.vocabularyId, this.concept, this.gloss, this.lemma});

  factory Synset.fromJson(Map<String, dynamic> parsedJson){
    print(parsedJson);
    return Synset(
      languageCode: parsedJson['languageCode'],
      vocabularyId: parsedJson['vocabularyId'].toString(),
      concept: parsedJson['concept'],
      gloss: parsedJson['gloss'],
      lemma: parsedJson['lemma'],

    );
  }
}
