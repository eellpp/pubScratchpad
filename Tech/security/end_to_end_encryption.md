### How E2E is done generally  
https://hacks.mozilla.org/2018/11/firefox-sync-privacy/    

 We use 1000 rounds of PBKDF2 to derive your passphrase into the authentication token1. On the server, we additionally hash this token with scrypt (parameters N=65536, r=8, p=1)2 to make sure our database of authentication tokens is even more difficult to crack.

We derive your passphrase into an encryption key using the same 1000 rounds of PBKDF2. It is domain-separated from your authentication token by using HKDF with separate info values. We use this key to unwrap an encryption key (which you generated during setup and which we never see unwrapped), and that encryption key is used to protect your data.  We use the key to encrypt your data using AES-256 in CBC mode, protected with an HMAC3.
