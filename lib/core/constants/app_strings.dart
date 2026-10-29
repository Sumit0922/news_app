abstract final class AppStrings {
  static const appName = 'Orbit';
  static const tagline = 'A wider perspective.';

  static const welcome = 'Stay informed.\nThink ahead.';
  static const loginSubtitle =
      'Your daily briefing on business, technology, and the world.';

  static const email = 'Email address';
  static const emailHint = 'you@example.com';
  static const password = 'Password';
  static const passwordHint = 'At least 8 characters';
  static const remember = 'Remember my session';
  static const signIn = 'Start exploring';

  static const demoNotice =
      'Demo sign-in. Use any valid email and a password of '
      '8–72 characters. No account is created.';

  static const emailRequired = 'Enter your email address.';
  static const emailInvalid = 'Enter a valid email address.';
  static const passwordRequired = 'Enter your password.';
  static const passwordInvalid = 'Use 8–72 characters.';
  static const showPassword = 'Show password';
  static const hidePassword = 'Hide password';

  static const discover = 'Discover';
  static const latest = 'Your daily briefing';
  static const feedSubtitle =
      'The stories that matter. A perspective worth keeping.';

  static const bookmarks = 'Saved';
  static const savedTitle = 'Your reading list';
  static const savedSubtitle = 'Good stories deserve a second look.';

  static const settings = 'Settings';
  static const search = 'Search a topic or keyword';
  static const clearSearch = 'Clear search';

  static const retry = 'Try again';
  static const loading = 'Preparing your briefing';
  static const loadingMore = 'Loading more stories';
  static const loadMore = 'More stories';

  static const noResults = 'A fresh perspective awaits';
  static const noResultsBody =
      'We couldn’t find stories for this search. '
      'Try a broader keyword or explore another category.';

  static const noSaved = 'Keep the stories that matter';
  static const noSavedBody =
      'Save a story using its bookmark button. '
      'Your reading list will appear here.';

  static const noInternet =
      'We couldn’t reach the news service. '
      'Check your connection and try again.';

  static const timeout =
      'This is taking longer than expected. '
      'Please check your connection and try again.';

  static const invalidResponse =
      'We couldn’t read this news feed. Please try again shortly.';

  static const serverError =
      'The news feed is temporarily unavailable. '
      'Please try again shortly.';

  static const rateLimit =
      'This news source needs a short break. '
      'Please wait a moment before trying again.';

  static const unknownError =
      'Something interrupted your briefing. Please try again.';

  static const storageError =
      'Couldn’t save changes on this device. Please try again.';

  static const cacheNotice =
      'Showing a saved copy. Refresh when you’re connected.';

  static const persistenceNotice =
      'News is available, but the saved copy couldn’t be updated.';

  static const refresh = 'Refresh';
  static const endOfFeed = 'You’ve reached the end of this briefing';

  static const save = 'Save story';
  static const remove = 'Remove saved story';
  static const saved = 'Added to your reading list';
  static const removed = 'Removed from your reading list';

  static const summary = 'The briefing';
  static const noSummary =
      'A summary isn’t available for this story. '
      'Open the original article to continue reading.';

  static const readOriginal = 'Read full story';
  static const originalNotice =
      'The original article opens on the publisher’s website '
      'and requires an internet connection.';

  static const sourceCredit =
      'Category headlines from BBC News RSS. '
      'Search discovery through Google News RSS. '
      'Content belongs to the original publishers.';

  static const openFailed = 'Couldn’t open the original article.';
  static const storyMissing =
      'This story is no longer available on this device.';
  static const backToFeed = 'Back to Discover';

  static const appearance = 'Appearance';
  static const themeSubtitle = 'Make yourself comfortable';
  static const light = 'Light';
  static const dark = 'Dark';
  static const system = 'System';

  static const account = 'Your session';
  static const logout = 'Log out';
  static const logoutBody =
      'Your reading list stays on this device for this email address.';
  static const cancel = 'Cancel';

  static const about = 'About Orbit';
  static const aboutBody =
      'A considered space for your daily news. '
      'Browse BBC category feeds, discover stories through '
      'Google News RSS search, and save articles for later. '
      'Previously loaded headlines appear while fresh news loads. '
      'Saved feed excerpts and downloaded images are available offline. '
      'Full articles open on the publisher’s website. '
      'Uninstalling the app removes local data.';

  static const startupError =
      'We couldn’t open local storage. '
      'Check the available space on your device and try again.';

  static const imageUnavailable = 'Story image unavailable';
  static const storyImage = 'Story photograph';
  static const saving = 'Saving story';

  static String bySource(String source) => 'From $source';
}
