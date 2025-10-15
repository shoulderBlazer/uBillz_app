String capitalizeWords(String text) {
  if (text.isEmpty) return text;

  return text.split(' ').map((word) {
    if (word.isEmpty) return word;

    // If the word is all uppercase, preserve it (e.g., 'TV', 'SKY').
    if (word == word.toUpperCase()) {
      return word;
    }

    // Otherwise, capitalize the first letter and lowercase the rest.
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}
