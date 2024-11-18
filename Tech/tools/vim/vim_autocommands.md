https://learnvimscriptthehardway.stevelosh.com/chapters/12.html

Let’s break down the command:

### Command:
```vim
:autocmd BufWritePre *.html :normal gg=G
```

---

### 1. **`:autocmd`**
- This defines an **automatic command** that is triggered when specific events occur in Vim.

---

### 2. **`BufWritePre`**
- This is the **event** that triggers the `autocmd`.
- **`BufWritePre`**:
  - It runs just before a buffer (file) is written to disk.
  - In this case, it ensures the specified action (`:normal gg=G`) happens before saving the file.

---

### 3. **`*.html`**
- This is the **file pattern** for which the `autocmd` applies.
- **`*.html`**:
  - Matches all files with the `.html` extension.
  - The command will trigger only for HTML files.

---

### 4. **`:normal`**
- The `:normal` command allows you to execute a sequence of normal-mode commands.

---

### 5. **`gg=G`**
This sequence is executed in normal mode and performs the following:

#### **`gg`**
- Moves the cursor to the **beginning of the file**.

#### **`=`**
- The `=` command in normal mode is used for **indentation**.
- When followed by a motion (like `G`), it automatically adjusts the indentation for the specified lines.

#### **`G`**
- Moves the cursor to the **end of the file**.

**Combined**: `gg=G`
- Reindents the entire file:
  1. Starts from the top (`gg`).
  2. Reindents lines up to the end of the file (`=G`).

---

### Overall Effect:
The `:autocmd` ensures that:
1. Whenever you save an HTML file (triggered by `BufWritePre`), Vim automatically:
   - Reindents the entire file before saving.
2. This ensures the file is always formatted properly (with correct indentation) before being written to disk.

---

### Example:
1. Open an unformatted `.html` file:
   ```html
   <html>
   <body><h1>Title</h1></body>
   </html>
   ```

2. Save the file (`:w`).

3. After saving, Vim will reindent the file:
   ```html
   <html>
       <body>
           <h1>Title</h1>
       </body>
   </html>
   ```

---

### Summary:
This command ensures all `.html` files are automatically reindented before being saved, helping maintain consistent formatting. Let me know if you need further clarification!
