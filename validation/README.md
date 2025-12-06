# Data Validation Scripts

This package contains validation scripts for the `data/4` folder structure.

## Requirements

- Flutter Version Manager (fvm) with Flutter 3.32.7+ (Dart 3.8.1+)
- The `dto` package from the kazky-dytynstva repository

## Installation

```bash
cd validation
fvm dart pub get
```

## Usage

### Validate data/4 folder

Run the validation script to check the data/4 folder structure and content:

```bash
cd validation
fvm dart run bin/validate_data_4.dart
```

## What it validates

The `validate_data_4.dart` script performs the following checks:

### 1. Folder Existence
- ✅ Checks that `data/4` folder exists

### 2. Folder Structure
- ✅ Validates presence of `data/4/people` folder
- ✅ Validates presence of `data/4/tales` folder
- ✅ Checks for `list.json` in both folders

### 3. JSON Parsing
- ✅ Parses `data/4/people/list.json` into `PersonDto` list
- ✅ Parses `data/4/tales/list.json` into `TaleDto` list
- ✅ Detects duplicate IDs in both lists

### 4. People Folder Structure
For each person in the list:
- ✅ Checks that a folder exists with the person's ID
- ⚠️ Warns if `photo.thumbnail.jpg` is missing
- ⚠️ Warns if `photo.original.jpg` is missing
- ⚠️ Warns about unexpected files
- ⚠️ Warns about orphaned folders (folders without corresponding entry in list.json)

Expected structure:
```
data/4/people/
  list.json
  {id}/
    photo.thumbnail.jpg
    photo.original.jpg
```

### 5. Tales Folder Structure
For each tale in the list:
- ✅ Checks that a folder exists with the tale's ID
- ⚠️ Warns if `audio.mp3` is missing
- ⚠️ Warns if `img/` folder is missing or empty
- ⚠️ Warns about unexpected files
- ⚠️ Warns about orphaned folders (folders without corresponding entry in list.json)

Expected structure:
```
data/4/tales/
  list.json
  {id}/
    audio.mp3
    img/
      0.jpg
      1.jpg
      ...
```

## Exit Codes

- `0` - Validation passed (warnings are allowed)
- `1` - Validation failed (errors detected)

## Current Validation Results

The validation script identifies structural issues that need to be fixed in the data/4 folder:

### Tale Images
Tales must have image pairs in the `img/` folder:
- `{index}.thumbnail.jpg` - Thumbnail version
- `{index}.original.{ext}` - Original version (any format)
- Must start with index 0
- Indices must be sequential (0, 1, 2, 3, ...)

Many tales currently only have thumbnails without corresponding originals, which causes validation errors.

### Tale Audio
Tales with the "audio" tag must have an `audio/` folder containing:
- `audio.mp3` - Required processed audio file
- `original.{ext}` - Optional original audio file (any format)

### Person Photos  
Each person folder must have exactly 2 files:
- `photo.thumbnail.jpg` - Required thumbnail
- `photo.original.{ext}` - Required original (any format, but only one file)

## Output

The script outputs:
- ✅ Success messages for passed validations
- ⚠️ Warnings for non-critical issues
- ❌ Errors for critical issues

At the end, it provides a summary:
- Total number of errors
- Total number of warnings
- Detailed list of all errors and warnings
