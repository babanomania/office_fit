import 'package:office_fit/models/ActivityViewModel.dart';

class AddActivity {
  final ActivityViewModel item;

  AddActivity(this.item);
}

class EditActivity {
  final ActivityViewModel item;

  EditActivity(this.item);
}

class RemoveActivity {
  final ActivityViewModel item;

  RemoveActivity(this.item);
}

class SelectActivity {
  final ActivityViewModel item;

  SelectActivity(this.item);
}

class DoActivity {
  final ActivityViewModel item;

  DoActivity(this.item);
}

class UndoActivity {
  final ActivityViewModel item;

  UndoActivity(this.item);
}