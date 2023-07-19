
https://deliciousbrains.com/how-unicode-works/

https://blog.hubspot.com/website/what-is-utf-8


Back in the day when Unix was getting invented, characters were represented with 8 bits (1 byte) of memory.  

ASCII was created to help with this and is essentially a lookup table of bytes to characters.  

The ASCII table has 128 standard characters (both upper and lower case a-z and 0-9). There are actually only 95 alphanumeric characters, which sounds fine if you speak English. In actual fact each character only requires 7 bits, so there’s a whole bit left over! This led to the creation of the extended ASCII table which has 128 more fancy things like Ç and Æ as well as other characters. 

Unicode is really just another type of character encoding, it’s still a lookup of bits -> characters. The main difference between Unicode and ASCII is that Unicode allows characters to be up to 32 bits wide. That’s over 4 billion unique values. 

### Unicode Vs Unicode Encodings (like UTF-8)
But with Unicode, won’t all my documents, emails and web pages take up 4x the amount of space compared with ASCII? Well, luckily no. Together with Unicode comes several mechanisms to represent or encode the characters. These are primarily the UTF-8 and UTF-16 encoding schemes which both take a really smart approach to the size problem.

Unicode encoding schemes like UTF-8 are more efficient in how they use their bits. With UTF-8, if a character can be represented with 1 byte that’s all it will use. If a character needs 4 bytes it’ll get 4 bytes. This is called a variable length encoding and it’s more efficient memory wise. Unicode encodings are simply how a piece of software implements the Unicode standard.


UTF-8 saves space. In UTF-8, common characters like “C” take 8 bits, while rare characters like “💩” take 32 bits. Other characters take 16 or 24 bits. A blog post like this one takes about four times less space in UTF-8 than it would in UTF-32. So it loads four times faster.

### UTF-16 encodings
JavaScript engines use UTF-16 internally, another variable length encoding. If you remember UTF-16 is a lot like UTF-8 except that the lowest amount of bits used is 16. Simple characters like ‘C’ use 16 bits, while fancy characters use 32 bits.   

