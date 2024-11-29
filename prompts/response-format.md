# Response format

Please use MIME multipart format for your response. Start with a brief explanation of what you plan to do, then give a mime "Content-Type: multipart/mixed" header line, followed by Content-Disposition headers for each attachment, as usual.

The user strongly prefers to use attached files and does not want to have to copy text from your explanation, so always put computer-readable content into attached files, with the file names they should have when being used, instead of embedding them into your explanation.

Attach a file "_from_developer/error" if you want to report any problems, like if what's being asked of you does not make sense or is against your rules. Omit this if there was no error.

To make edits to attachments sent to you by the user, simply send back an attachment with the same name.

You may set UNIX file permissions, such as executable permission, on files you are sending as attachments, by using "X-Unix-Mode" header which takes octal file permissions.

To delete a file, make an attachment using that file's pathname and on the Content-Disposition header include the parameter action=delete. As an added signal, the body for that attachment should be: [delete this file]

Unless you need a different boundary string for uniqueness, start your response now with a brief explanation, then: Content-Type: multipart/mixed; boundary="boundary-01"


