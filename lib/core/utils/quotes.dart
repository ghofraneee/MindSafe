/// A mental wellness quote with author attribution.
class WellnessQuote {
  const WellnessQuote({
    required this.text,
    required this.author,
  });

  final String text;
  final String author;
}

/// Curated mental wellness quotes for daily inspiration.
const List<WellnessQuote> wellnessQuotes = [
  WellnessQuote(
    text: 'You don\'t have to control your thoughts. You just have to stop letting them control you.',
    author: 'Dan Millman',
  ),
  WellnessQuote(
    text: 'The only way out is through.',
    author: 'Robert Frost',
  ),
  WellnessQuote(
    text: 'Self-care is giving the world the best of you, instead of what\'s left of you.',
    author: 'Katie Reed',
  ),
  WellnessQuote(
    text: 'You are not your illness. You have an individual story to tell.',
    author: 'Julian Seifter',
  ),
  WellnessQuote(
    text: 'There is hope, even when your brain tells you there isn\'t.',
    author: 'John Green',
  ),
  WellnessQuote(
    text: 'What mental health needs is more sunlight, more candor, and more unashamed conversation.',
    author: 'Glenn Close',
  ),
  WellnessQuote(
    text: 'Healing takes time, and asking for help is a courageous step.',
    author: 'Mariska Hargitay',
  ),
  WellnessQuote(
    text: 'You, yourself, as much as anybody in the entire universe, deserve your love and affection.',
    author: 'Buddha',
  ),
  WellnessQuote(
    text: 'It\'s okay to not be okay — as long as you are not giving up.',
    author: 'Karen Salmansohn',
  ),
  WellnessQuote(
    text: 'Your present circumstances don\'t determine where you can go; they merely determine where you start.',
    author: 'Nido Qubein',
  ),
  WellnessQuote(
    text: 'Feelings are just visitors. Let them come and go.',
    author: 'Mooji',
  ),
  WellnessQuote(
    text: 'The strongest people are those who win battles we know nothing about.',
    author: 'Unknown',
  ),
  WellnessQuote(
    text: 'Rest when you\'re weary. Refresh and renew yourself, your body, your mind, your spirit.',
    author: 'Ralph Marston',
  ),
  WellnessQuote(
    text: 'Be patient with yourself. Nothing in nature blooms all year.',
    author: 'Unknown',
  ),
  WellnessQuote(
    text: 'You are allowed to be both a masterpiece and a work in progress simultaneously.',
    author: 'Sophia Bush',
  ),
  WellnessQuote(
    text: 'Mental health is not a destination, but a process. It\'s about how you drive, not where you\'re going.',
    author: 'Noam Shpancer',
  ),
  WellnessQuote(
    text: 'Sometimes the most productive thing you can do is relax.',
    author: 'Mark Black',
  ),
  WellnessQuote(
    text: 'Talk to yourself like you would to someone you love.',
    author: 'Brené Brown',
  ),
  WellnessQuote(
    text: 'Almost everything will work again if you unplug it for a few minutes — including you.',
    author: 'Anne Lamott',
  ),
  WellnessQuote(
    text: 'The journey of a thousand miles begins with a single step.',
    author: 'Lao Tzu',
  ),
  WellnessQuote(
    text: 'Courage doesn\'t always roar. Sometimes courage is the quiet voice at the end of the day saying, "I will try again tomorrow."',
    author: 'Mary Anne Radmacher',
  ),
  WellnessQuote(
    text: 'Your mind will answer most questions if you learn to relax and wait for the answer.',
    author: 'William S. Burroughs',
  ),
  WellnessQuote(
    text: 'Happiness can be found even in the darkest of times, if one only remembers to turn on the light.',
    author: 'Albus Dumbledore',
  ),
  WellnessQuote(
    text: 'Breathe. Let go. And remind yourself that this very moment is the only one you know you have for sure.',
    author: 'Oprah Winfrey',
  ),
];

/// Returns a deterministic quote for the current day of the year.
WellnessQuote pickQuoteForToday({DateTime? date}) {
  final now = date ?? DateTime.now();
  final startOfYear = DateTime(now.year);
  final dayOfYear = now.difference(startOfYear).inDays;
  final index = dayOfYear % wellnessQuotes.length;
  return wellnessQuotes[index];
}

/// Returns a quote at a specific index, wrapping around the list.
WellnessQuote pickQuoteAtIndex(int index) {
  final safeIndex = index % wellnessQuotes.length;
  return wellnessQuotes[safeIndex];
}
