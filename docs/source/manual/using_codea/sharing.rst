:reference-section: Sharing & Storage

Sharing and exporting projects
==============================

Choose a sharing method based on what the recipient needs: a playable project, editable source, or a standalone app project.

Share a playable link
---------------------

1. Touch and hold your project and choose **Share Playable Link…**.
2. Use **Preview Your Project** to check the experience.
3. Choose **Create Link** and wait for the upload to finish.
4. Choose **Share Link** to send or copy the result using the system share sheet.

Anyone with the link can play your uploaded project on an iOS device. Links expire 30 days after creation or an update.

After changing the project, return to this screen and choose **Update Shared Project…** to publish the latest version at the same link. Local edits do not automatically update the uploaded version.

Send editable source
--------------------

Choose **Send Project File…** to share the project document through the system share sheet. **Export > Zipped Project** packages it as an archive. **Export > Copy Code** copies the code as text; use a project file or archive when the recipient also needs its assets.

Export an Xcode project
-----------------------

1. Open the project's menu and choose **Export > Xcode Project**.
2. Complete the export settings and follow the export flow.
3. Save or transfer the generated archive to your Mac, then extract and open the generated project in Xcode.
4. Configure the app's signing and destination in Xcode, then build and test it there.

Xcode export requires Codea Pro. Build and test the exported app before submitting it to the App Store.

Export an Android project
-------------------------

For a **modern** project, choose **Export > Android Project**. This option is marked **Beta** and requires Codea Pro; it is not offered for the legacy renderer. Complete the export settings, save the archive, then extract it on your computer and open the generated Gradle project in Android Studio.

Test the exported app on Android, especially any platform-specific features.
