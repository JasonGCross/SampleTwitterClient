# SampleTwitterClient
Proof of concept app.
Allows the user to authenticate against the Twitter API using a single account, the developer's account.
After login, shows a list of Tweets from the developer's account home timeline.
Allows logging off.
That's it! No posting of new tweets or refresh ability.
Note that the app caches previously-retrieved tweets and only fetches any new tweets, after each login.

##How to Run
This project is built using Xcode 6.1. To run the app in the simulator, download the source code and run. The username / password fields are currently disabled. Just press "login" to use the saved developer credentials.

After logging in, a list of tweets is shown. Only newer tweets since the last API call are fetched from the server; the rest are already cached in memory. Currently the only way to fetch new tweets is to logout (top left button) and log in again, or just restart the app.

##Technology Notes
This project uses CoreData to cache tweets previously received by the API. It uses MKNetworkEngine for retrieving images. Rather than use a 3rd party library for authenticating and communicating with the Twitter API, the stock Apple libraries are used (Accounts framework, Social Framework).

The model objects in the iOS code match exactly the property names used by the Twitter JSON. This makes deserializing the model objects very simple; just use [NSObject setValuesForKeysInDictionary] and the JSON representation is deserialized into native Objective-C objects.

Table view cells are "smart" in that the calling view controller does not need to know the Nib name or the reuse identifier; nor does the table view need to be registered for the Nib or Class. The table cell itself looks after all these details. A "bind" method on the table cell hides all the details of hooking up model object code to views, thus making a neat and clean implementation of [UITableViewDataSource cellForRowAtIndexPath].

Note that in this proof-of-concept, the cached tweets will grow without bounds. Obviously, a real app would need to clean up (delete) old tweets in order to only use a reasonable amount of device storage space.

