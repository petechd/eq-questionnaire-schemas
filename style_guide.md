### Variables

- Variable names should start with a lowercase character, subsequent words should be capitalised (`camelCase` styling).
  ```
  // CORRECT
  local myExampleVariable = 1;
  // camelCase

  // INCORRECT
  local my_exampe_variablle = 1;
  ```
- Enclose strings in single quotation marks for consistency.

- Be aware of the reserved keywords:
   ```
  assert else error false for function if import importstr in local null tailstrict then self super true
  ```
  
- Use descriptive, self-evident naming.

- When declaring variables use `local` instead of `::`. This prevents them from being overridden or accessed externally.

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
- To separate class definitions use two blank lines.
- Excessive number of blank lines is discouraged.


### Classes
- Use `local` syntax to prevent from being overridden or accessed externally.
- Surround top-level function and class definitions with two blank lines.
- Class names should follow the same convention as variable names.
- Class close braces should be followed by a semicolon.
- To define a class, use syntax:
  ```
  local newClass(parameter1, parameter2) = {
    parameter1: parameter1,
    parameter2: parameter2,
  };
  ```

- Optional parameters of a class should be placed after required parameters and assigned default or `null` value.

- Parameter declarations should be wrapped by putting one per line with two extra spaces of indentation, to differentiate from the method body.
  ```
  local newClass(
      parameter1,
      parameter2,
      parameter3 = true) = { 
    parameter1: parameter1,
    ...
  };
  ```
- Can also return dictionary to expose constants, static methods or related class constructors.

### Methods
- Use blank lines in methods to indicate logical sections.
- Use same syntactic style as class definitions.
- Methods fail to render with `:`, should always be defined with `::`.
- Use parentheses `()` when using Methods that return single value, to enclose their bodies if they are multi-line, identically to how braces would be used.
  ```
  {
    add:: function(number1, number2): (
      number1 + number 2
    ),
  };
  ```

- When constructing classes or invoking methods, use named parameters, one per line, especially when they wrap beyond one line:
  ```
  // USE
  exampleTemplate.newClass(
    parameter1 = "string",
    parameter2 = 0,
  )

  // INSTEAD OF
  examoleTemplate.newClass("string", 0)
  // It does not wrap
  ```

### Imports

- Dependencies should be imported at the top of the file. 
- Names should be related to the imported file itself. It makes it easier checking files you depend on as the file expands.
- Put on separate lines, followed by a semicolon.

### File Structure

- Because we don't use `templates` at the moment and there are no further inputs, Jsonnet files end with the ".jsonnet" suffix.

### Documentation Style

- Use single line JavaScript's `//` for comments.

### Formatting

- For basic style errors use `jsonnet fmt`.
