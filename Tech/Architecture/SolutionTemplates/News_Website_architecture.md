
Like HN. Article Post and comments 

### Backend 

Entities 
- article : required
- user : anonymous reading is possible
- comment : a registered user can have comment


**article table** 

| column      | description             |
| ----------- | ----------------------- |
| articleid   |                         |
| url         | local url for article   |
| srcurl      | source url              |
| title       | title                   |
| text        | brief description about |
| datecreated |                         |
| dateupdated |                         |


**user table**

| column      | description |
| ----------- | ----------- |
| userid      |             |
| name        |             |
| email       |             |
| password    |             |
| datecreated |             |
| dateupdated |             |

**comment table**

| column      | description |
| ----------- | ----------- |
| commentid   |             |
| userid      |             |
| articleid   |             |
| parentid    |             |
| datecreated |             |
| dateupdated |             |

This will query database for a articleid and return a nested json of comments for the page

```python
def get_comments(article_id):
        all_comments = get_comments_for_articleid(article_id)
        comment_map = {} 
        result = []
        for c in all_comments :
	        if not c.get("parentid"):
		        result.add(c)
			comment_map.update({c["commentid"] : c})
        for c in all_comments:
	        if c.get("parentid"):
		        parent = comment_map[c.get("parentid")]
		        if not parent.get("child"):
			        parent["child"] = []
			    parent["child"].append(c)
		
         return result
```
```
```


reference : https://programmer.group/database-design-and-implementation-of-comment-system.html


### Frontend 

nested comment svelte snippet 
https://svelte.dev/repl/a430ebc326824c7084ff06fac0d27bc8?version=3.49.0  

Official svelte hn example
https://svelte.dev/examples/hacker-news

svelte-infinite-loading - Hacker News with Filter
https://svelte.dev/repl/73d404d5a26a47db969c4ebc154e8079?version=3.49.0


