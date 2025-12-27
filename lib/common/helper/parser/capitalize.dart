String capitalizeWords(String input) {
  if (input.isEmpty) return input;

  return input
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        final firstLetter = word[0].toUpperCase();
        final rest = word.substring(1).toLowerCase();
        return '$firstLetter$rest';
      })
      .join(' ');
}
