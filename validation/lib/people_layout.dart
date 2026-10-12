import 'dart:io';

import 'package:path/path.dart' as path;

/// The derived people catalogue of [root] (`data/4/people/index.json`).
File readyPeopleListFile(Directory root) =>
    File(path.join(root.path, 'data', '4', 'people', 'index.json'));
