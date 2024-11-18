
### Encrypt the file temporarily with ROT13 

 ```bash
<Escape> ggg?G
   ```


**Explanation of the Commands:**  
- **`gg`**: Moves the cursor to the first line of the file.
- **`g?G`**: Applies the ROT13 transformation from the current position (`gg`, the start of the file) to the end of the file (`G`).

To unscramble ROT13 text in Vim, you can reapply the same `g?` command, as ROT13 is a symmetric cipher. Applying ROT13 twice returns the original text.
