class FormDataModel {
  Data? data;

  FormDataModel({this.data});

  FormDataModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sTypename;
  GetUserForm? getUserForm;

  Data({this.sTypename, this.getUserForm});

  Data.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    getUserForm = json['getUserForm'] != null ? GetUserForm.fromJson(json['getUserForm']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    if (getUserForm != null) {
      data['getUserForm'] = getUserForm!.toJson();
    }
    return data;
  }
}

class GetUserForm {
  String? sTypename;
  int? id;
  String? name;
  String? formUuid;
  bool? isEditable;
  List<Questions>? questions;

  GetUserForm({this.sTypename, this.id, this.name, this.formUuid, this.isEditable, this.questions});

  GetUserForm.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    id = json['id'];
    name = json['name'];
    formUuid = json['formUuid'];
    isEditable = json['isEditable'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['id'] = id;
    data['name'] = name;
    data['formUuid'] = formUuid;
    data['isEditable'] = isEditable;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String? sTypename;
  int? id;
  String? question;
  String? questionType;
  String? answerType;
  int? maxLines;
  String? hintText;
  bool? isEnabled;
  String? reValidation;
  dynamic reValidationText;
  bool? isMandatoryField;
  List<Options>? options;
  dynamic userResponse;

  Questions(
      {this.sTypename,
      this.id,
      this.question,
      this.questionType,
      this.answerType,
      this.maxLines,
      this.hintText,
      this.isEnabled,
      this.reValidation,
      this.reValidationText,
      this.isMandatoryField,
      this.options,
      this.userResponse});

  Questions.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    id = json['id'];
    question = json['question'];
    questionType = json['questionType'];
    answerType = json['answerType'];
    maxLines = json['maxLines'];
    hintText = json['hintText'];
    isEnabled = json['isEnabled'];
    reValidation = json['reValidation'];
    reValidationText = json['reValidationText'];
    isMandatoryField = json['isMandatoryField'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    userResponse = json['userResponse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['id'] = id;
    data['question'] = question;
    data['questionType'] = questionType;
    data['answerType'] = answerType;
    data['maxLines'] = maxLines;
    data['hintText'] = hintText;
    data['isEnabled'] = isEnabled;
    data['reValidation'] = reValidation;
    data['reValidationText'] = reValidationText;
    data['isMandatoryField'] = isMandatoryField;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    data['userResponse'] = userResponse;
    return data;
  }
}

class Options {
  String? sTypename;
  int? id;
  String? name;
  String? formUuid;
  bool? isEditable;
  List<Questions>? questions;
  String? option;

  Options({this.sTypename, this.id, this.name, this.formUuid, this.isEditable, this.questions, this.option});

  Options.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    id = json['id'];
    name = json['name'];
    formUuid = json['formUuid'];
    isEditable = json['isEditable'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
    option = json['option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['id'] = id;
    data['name'] = name;
    data['formUuid'] = formUuid;
    data['isEditable'] = isEditable;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    data['option'] = option;
    return data;
  }
}

// class Questions {
//   String? sTypename;
//   int? id;
//   String? question;
//   String? questionType;
//   String? answerType;
//   int? maxLines;
//   String? hintText;
//   bool? isEnabled;
//   Null? reValidation;
//   Null? reValidationText;
//   bool? isMandatoryField;
//   List<Null>? options;
//   Null? userResponse;
//
//   Questions(
//       {this.sTypename,
//         this.id,
//         this.question,
//         this.questionType,
//         this.answerType,
//         this.maxLines,
//         this.hintText,
//         this.isEnabled,
//         this.reValidation,
//         this.reValidationText,
//         this.isMandatoryField,
//         this.options,
//         this.userResponse});
//
//   Questions.fromJson(Map<String, dynamic> json) {
//     sTypename = json['__typename'];
//     id = json['id'];
//     question = json['question'];
//     questionType = json['questionType'];
//     answerType = json['answerType'];
//     maxLines = json['maxLines'];
//     hintText = json['hintText'];
//     isEnabled = json['isEnabled'];
//     reValidation = json['reValidation'];
//     reValidationText = json['reValidationText'];
//     isMandatoryField = json['isMandatoryField'];
//     if (json['options'] != null) {
//       options = <Null>[];
//       json['options'].forEach((v) {
//         options!.add(new Null.fromJson(v));
//       });
//     }
//     userResponse = json['userResponse'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['__typename'] = this.sTypename;
//     data['id'] = this.id;
//     data['question'] = this.question;
//     data['questionType'] = this.questionType;
//     data['answerType'] = this.answerType;
//     data['maxLines'] = this.maxLines;
//     data['hintText'] = this.hintText;
//     data['isEnabled'] = this.isEnabled;
//     data['reValidation'] = this.reValidation;
//     data['reValidationText'] = this.reValidationText;
//     data['isMandatoryField'] = this.isMandatoryField;
//     if (this.options != null) {
//       data['options'] = this.options!.map((v) => v.toJson()).toList();
//     }
//     data['userResponse'] = this.userResponse;
//     return data;
//   }
// }
