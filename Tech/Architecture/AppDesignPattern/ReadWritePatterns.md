Write Heavy applications

 A common example is applications where you want to keep the user's state saved frequently, but you only need to reload it when the application is restarted. A lot of games work this way. So there can be a write every few seconds or every minute for every active user, but you only need to do a read a few times at the beginning of a new session.

lots of modern document software, for instance, basically saves continuously; so a Google Docs-style application could have such a load.
