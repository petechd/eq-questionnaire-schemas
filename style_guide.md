# Jsonnet Style Guide
This style guide documents how we want to handle jsonnet files when building the schemas with consistency. For more general principles and styling rules go to ["Databricks repository"](https://github.com/databricks/jsonnet-style-guide#databricks-jsonnet-guide).


##Folder structure
###England/Wales and Northern Ireland
- Jsonnet source files are separated into two folders: "england-wales" and "northern-ireland" with a number of sub-folders, each for corresponding schemas (e.g. "css", "communal-establishment", "household", "individual"). These are divided into blocks in "blocks" folder.
###Top level Jsonnet files in these folders
- For each schema there is a lists of block and placeholder imports, as well as schema structure divided into sections, named after given schema and ending with ".jsonnet" suffix.


##Common Jsonnet

###Lib folders
- Rules and placeholders are located in "lib" folder in corresponding schemas along with blocks folder.
###Rules and placeholders
- These are separated into: 'common_rules', 'placeholders' and 'rules'. These files should end with ".libsonnet" suffix.
###Top level and extended
- "common_rules" and "placeholders" are located in top level "lib" folder.
- "rules" files for each schema are located in schema's sub-folder and extend some of the top-level "common_rules".

##Global variables
###Top level arguments
- region code, census month year date.
###External variables 
- External variables are being used. Example of that is "census date".
###Region Code
- Why don't we treat region code like census date?

##Blocks
###Structure
- imports, variables, methods, block json.
###Block json
- block json can be a function if an argument is being passed.
###Variants
- Where variants exist, a question method should be used and be passed the variables that control the variant e.g. isProxy.

##Shared blocks
- Blocks from "individual" folder are used in both household and individual schema.

##Difference between this style guide and "Databricks"
- Lines should be limited to 79 characters.