# Jsonnet Style Guide
This style guide documents how we want to handle jsonnet files when building the schemas with consistency. For more general principles and styling rules go to ["Databricks repository"](https://github.com/databricks/jsonnet-style-guide#databricks-jsonnet-guide).


##Folder structure
###England/Wales and Northern Ireland
###Top level Jsonnet files in these folders

##Common Jsonnet
###Lib folders
###Rules and placeholders
###Top level and extended

##Global variables
###Top level arguments
- region code, census month year date
###External variables 
- census date
###Region Code
- Why don't we treat region code like census date?

##Blocks
###Structure
- imports, variables, methods, block json
###Block json
- block json can be a function if an argument is being passed
###Variants
- Where variants exist, a question method should be used and be passed the variables that control the variant e.g. isProxy

##Shared blocks
- Individual blocks used in household and individual
