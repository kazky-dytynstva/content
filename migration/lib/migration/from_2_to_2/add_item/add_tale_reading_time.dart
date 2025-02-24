class AddTaleReadingTime {
  const AddTaleReadingTime();

  final int _wordsPerMinuteSlow = 150;
  final int _wordsPerMinuteFast = 190;

  ReadingTime getReadingTime({
    required List<String> paragraphs,
  }) {
    int wordCount = 0;
    for (String text in paragraphs) {
      List<String> words =
          text.trim().split(' '); // Split by spaces and trim each item

      for (String word in words) {
        if (isWord(word)) {
          // Check if it's a word
          wordCount++;
        }
      }
    }

    int minReadingTime = (wordCount / _wordsPerMinuteFast).ceil();
    int maxReadingTime = (wordCount / _wordsPerMinuteSlow).ceil();

    return ReadingTime(minimum: minReadingTime, maximum: maxReadingTime);
  }

  bool isWord(String word) {
    if (word.isEmpty) return false; // Handle empty strings

    // Improved word check: Allow letters, numbers, hyphens, apostrophes, and some diacritics
    final value = RegExp(r"[\p{L}\p{N}]", unicode: true).hasMatch(word);

    if (value == false) {
      print('Word: $word');
    }

    return value;
  }
}

class ReadingTime {
  ReadingTime({
    required this.minimum,
    required this.maximum,
  });

  /// The minimum reading time in minutes.
  final int minimum;

  /// The maximum reading time in minutes.
  final int maximum;
}
