
### PEP 636 – Structural Pattern Matching: Tutorial (3.10)

https://peps.python.org/pep-0636/

You have decided to make an online version of your game. All of your logic will be in a server, and the UI in a client which will communicate using JSON messages.  
Via the json module, those will be mapped to Python dictionaries, lists and other builtin objects.  

Our client will receive a list of dictionaries (parsed from JSON) of actions to take, each element looking for example like these:  

>> {"text": "The shop keeper says 'Ah! We have Camembert, yes sir'", "color": "blue"}

If the client should make a pause:
>>  {"sleep": 3}

To play a sound:
>>  {"sound": "filename.ogg", "format": "ogg"}

Until now, our patterns have processed sequences, but there are patterns to match mappings based on their present keys. In this case you could use:

```python
for action in actions:
    match action:
        case {"text": message, "color": c}:
            ui.set_text_color(c)
            ui.display(message)
        case {"sleep": duration}:
            ui.wait(duration)
        case {"sound": url, "format": "ogg"}:
            ui.play(url)
        case {"sound": _, "format": _}:
            warning("Unsupported audio format")
```

The keys in your mapping pattern need to be literals, but the values can be any pattern. As in sequence patterns, all subpatterns have to match for the general pattern to match.

You can use **rest within a mapping pattern to capture additional keys in the subject. Note that if you omit this, extra keys in the subject will be ignored while matching, i.e. the message {"text": "foo", "color": "red", "style": "bold"} will match the first pattern in the example above.

