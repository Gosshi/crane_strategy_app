# User Content Expansion: YouTube Links

## Goal Description
Allow users to attach YouTube video URLs to their strategy posts. This enables crowdsourcing of "how-to-win" videos without hosting them directly, avoiding copyright and storage issues.

## User Review Required
> [!NOTE]
> **YouTube Links Only**
> Currently restricting to YouTube URLs to ensure safety and ease of embedding (via `url_launcher` or future player integration).

## Proposed Changes

### Data Model
#### [MODIFY] [post.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/data/models/post.dart)
- Add `final String? youtubeUrl;` field.
- Update `fromMap` and `toMap`.

### UI Components
#### [MODIFY] [post_composer_screen.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/presentation/screens/post_composer_screen.dart)
- Add a `TextField` for YouTube URL.
- Validate the URL (simple regex or `Uri.tryParse`).

#### [MODIFY] [scan_result_screen.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/presentation/screens/scan_result_screen.dart)
- Update the post list item to show a "Watch Video" button or chip if `youtubeUrl` is present.
- Use `url_launcher` to open the link.

## Verification Plan
### Manual Verification
- **Post Creation**: Create a post with a valid YouTube URL and verify it saves without error.
- **Display**: Verify the post appears in the list with a "Video" indicator.
- **Action**: Tap the indicator and verify it opens the YouTube app or browser.
