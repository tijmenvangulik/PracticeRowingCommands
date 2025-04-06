Server project for practice rowing commands

run the build script in the package.json to build the server

The practice rowing commands app can run without server. What the sever is storage of some data. You will get the following extra features:

* Game high scores
* Sharing settings with short url's (it will revert to long url's when there is no sever)
* Logging errors and finished practices
* Feed back information

The server requires a mongo db database. You can setup your own free server at mongodb.com or run your own mongodb server on your own machien.
In the Secrets.json fill in your connect string in the mongoDbConnect setting. In the mongodb database you will need to create a number of collections (mongo db collections do not need an columns):
* feedback
* sharedSettings
* gameHighScores
* logs

To get the high scores working your need to enter your own secrets in the Secrets.json and the secrets.gd file. The secrets should match on the server and the client side.

For local debugging change the server url to the constants.gd

const serverUrl="http://localhost:2024"

