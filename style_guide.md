# Jsonnet Style Guide
This style guide documents how we want to handle jsonnet files when building the schemas with consistency. For more general principles and styling rules go to ["Databricks repository"](https://github.com/databricks/jsonnet-style-guide#databricks-jsonnet-guide).

## Folder structure

### England/Wales and Northern Ireland

- Jsonnet source files are separated into two folders: `england-wales` and `northern-ireland` with a number of sub-folders, each for corresponding schemas (e.g. `ccs`, `communal-establishment`, `household`, `individual`). These are divided into blocks in `blocks` folder.

### Top level Jsonnet files in these folders

- For each schema there is a lists of block and placeholder imports, as well as schema structure divided into sections, named after given schema and ending with `.jsonnet` suffix.


## Common Jsonnet

### Lib folders

- Rules and placeholders are located in `lib` folder in corresponding schemas along with `blocks` folder.

### Rules and placeholders

- These are separated into: `common_rules`, `placeholders` and `rules`. These files should end with `.libsonnet` suffix.

### Top level and extended

- `common_rules` and `placeholders` are located in top level "lib" folder.
- `rules` files for each schema are located in schema's sub-folder and extend some of the top-level `common_rules`.

## Global variables

### Top level arguments

- For each schema created it is possible to pass variables, e.g.: `region_code` and `census_month_year_date`, with different outputs being generated depending on their value.

### External variables

- External variables are being used. Example of that is `census_month_year_date`.

### Region Code

- Depending on `region_code` variable's value, different structure of sections is generated (e.g. certain questions omitted).

## Blocks

### Structure

#### Imports

- They should be located at the top of the file.
- Line length limit doesn't apply.

#### Variables

- All the rules from ["Databricks style guide"](https://github.com/databricks/jsonnet-style-guide#databricks-jsonnet-guide) should be followed.
- Variables should be defined outside of methods.

#### Methods

- Methods should be treated differently when used inline vs top level.

### Block json

- Block json can be a function if an argument is being passed.

### Variants

- Where variants exist, a question method should be used and be passed the variables that control the variant, e.g. `isProxy`.

## Shared blocks

- Blocks from `individual` folder are used in both household and individual schema.

## Difference between this style guide and "Databricks"

- Lines should be limited to 79 characters.