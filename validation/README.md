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
- ❌ Error if `photo.thumbnail.jpg` is missing
- ❌ Error if `photo.original.*` is missing (any format accepted)
- ❌ Error if folder contains more than 2 files
- ❌ Error if folder contains unexpected files
- ❌ Error for orphaned folders (folders without corresponding entry in list.json)

Expected structure:
```
data/4/people/
  list.json
  {id}/
    photo.thumbnail.jpg
    photo.original.{ext}  # Any format: jpg, png, jpeg, webp, etc.
```

### 5. Tales Folder Structure
For each tale in the list:
- ✅ Checks that a folder exists with the tale's ID
- ❌ Error if `img/` folder is missing
- ❌ Error if `img/` folder doesn't have valid image pairs
- ❌ Error if tale has "audio" tag but `audio/` folder is missing
- ❌ Error if tale has `audio/` folder but no "audio" tag
- ❌ Error for unexpected files or folders
- ❌ Error for orphaned folders (folders without corresponding entry in list.json)

Expected structure:
```
data/4/tales/
  list.json
  list.json.gz        # Compressed version (gzip)
  {id}/
    img/
      0.thumbnail.jpg
      0.original.{ext}  # Any format
      1.thumbnail.jpg   # Optional, if tale has multiple images
      1.original.{ext}  # Optional
      ...
    audio/              # Only if tale has "audio" tag
      audio.mp3         # Required
      original.{ext}    # Optional, any format
```

### 6. Compressed Files
- ✅ Checks that `list.json.gz` exists for tales
- ✅ Checks that `list.json.gz` exists for people
- ✅ Validates compressed files can be decompressed
- ✅ Compares decompressed content matches original `list.json`
- ❌ Error if compressed file is missing
- ❌ Error if decompressed content doesn't match original
- ❌ Error if item counts differ between compressed and uncompressed

## Detailed Validation Rules

### Tale Images
Tales must have image pairs in the `img/` folder:
- `{index}.thumbnail.jpg` - Thumbnail version (must be JPG format)
- `{index}.original.{ext}` - Original version (any format: png, jpg, jpeg, webp, etc.)
- Must have at least one image pair with index 0
- All image pairs must have matching indices
- Indices must be sequential starting from 0 (0, 1, 2, 3, ...)

### Tale Audio
Tales with the "audio" tag **must** have an `audio/` folder containing:
- `audio.mp3` - Required processed audio file
- `original.{ext}` - Optional original audio file (any format)

Tales **without** the "audio" tag must **not** have an `audio/` folder.

### Person Photos  
Each person folder must have exactly 2 files:
- `photo.thumbnail.jpg` - Required thumbnail (must be JPG format)
- `photo.original.{ext}` - Required original (any format, but only ONE file)

No other files are allowed in person folders.

## Output

The script outputs:
- ✅ Success messages for passed validations
- ❌ Errors for validation failures

At the end, it provides a summary:
- Total number of errors
- Detailed list of all errors (if any)
