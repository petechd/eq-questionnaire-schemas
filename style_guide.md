### Variables

- Variable names should start with lowercase character, subsequent words are capitalised (camelCase styling).

- Enclose strings in single quotation marks for consistency.

- Be aware of the reserved keywords:
   ```
  assert else error false for function if import importstr in local null tailstrict then self super true
  ```
  
- Use descriptive, self-evident naming.

- When declaring variables use `local` instead of `::`, to prevent from being overridden or accessed externally.

### Line Length

- Limit all lines to a maximum of 79 characters (except import statements).

### Spacing and Indentation

- Spaces are the preferred indentation method.

- Use one space indentation:
   - Before and after operators.
   - After commas.
   - After colons.

- Otherwise, use two spaces.

- To differentiate parameters from function/class body, parameter declarations should use four space indentation. 

- Avoid extra whitespace in the following situations:
   - Inside parentheses, brackets or braces.
   - Between a trailing comma and a following close parenthesis.
   - Immediately before a comma, semicolon, or colon.
   - Around an assignment (or other) operator to align vertically.

- A single blank line appears:
  - Within method bodies, as needed to create logical groupings of statements.
  - Optionally before the first member or after the last member of a class or method.
- Use two blank lines to separate class definitions.
- Excessive number of blank lines is discouraged.


### Classes
- Use `local` syntax to prevent from being overridden or accessed externally.
- Surround top-level function and class definitions with two blank lines.
- Class names should follow the same convention as variable names.
- Class close braces should be followed by semicolon.

### Imports

- Import all dependencies at the top of the file. 
- Names should be related to the imported file itself. It makes it easier checking files you depend on as the file expands.
- Put on separate lines, followed by semicolon.

### File Structure

- Because we don't use `templates` at the moment, Jsonnet files with no further inputs should end with the ".jsonnet" suffix.

### Documentation Style

- Use single line JavaScript's `//` for comments.

### Formatting

- For basic style errors use `jsonnet fmt`.
