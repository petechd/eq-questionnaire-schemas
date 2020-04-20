# Jsonnet Style Guide
This style guide documents how we want to handle Jsonnet files when building the schemas with consistency. For more general principles and styling rules go to [Databricks repository](https://github.com/databricks/jsonnet-style-guide#databricks-jsonnet-guide).

## Folder structure
- The following structure is used:
```
    england-wales/
       ccs/
          blocks/
          lib/
             rules.libsonnet
       communal-establishment/
       household/
       individual/
       lib/
          common_rules.libsonnet
          placeholders.libsonnet
       ccs_household.jsonnet
       census_communal_establishment.jsonnet
       census_household.jsonnet
       census_individual.jsonnet
    northern-ireland/

```
### England/Wales and Northern Ireland

- Jsonnet source files are separated into two folders: `england-wales` and `northern-ireland` with a number of sub-folders, each for corresponding schemas (e.g. `ccs`, `communal-establishment`, `household`, `individual`). These are divided into blocks in `blocks` folder.

### Shared blocks

- Blocks from `individual` folder are used in both household and individual schema.

### Top level Jsonnet files

- For each schema there are lists of block and placeholder imports.
- Schema structure is divided into sections, named after given schema and ending with `.jsonnet` suffix.

## Common Jsonnet

### Lib folders

- Rules and placeholders are located in `lib` folder in corresponding schemas along with `blocks` folder.

### Rules and placeholders

- These are separated into: `common_rules`, `placeholders` and `rules`. These files should end with `.libsonnet` suffix.

### Top level and extended

- `common_rules` and `placeholders` are located in top-level "lib" folder.
- `rules` files for each schema are located in schema's sub-folder and extend some of the top-level `common_rules`.

## Global variables

### Top level arguments

- For each schema created it is possible to pass variables, e.g.: `region_code` and `census_month_year_date`, with different outputs being generated depending on their value.
- These are defined in eq-questionnaire-runner, are known at questionnaire launch and won't change during the Census.

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

- Variables should be defined according to general principles and styling rules.

#### Methods

- We should define a method each time we’re changing a property, e.g. in individual→blocks→identity-and-health→carer.jsonnet:
    - question should be called with question(isProxy=true) or question(isProxy=false)
    - In the question method, when we need to resolve title, we call a new questionTitle method, passing isProxy
    - In the questionTitle method we would return either of the two strings, based on the isProxy variable
    - We would then do a similar thing for guidance with a questionGuidance method
- Methods can be invoked at top-level or declared inline, depending on the intended use:
```
    // TOP-LEVEL
    
    local proxyTitle = {
      text: 'Does <em>{person_name}</em> mainly work in the UK?',
      placeholders: [placeholders.personName,],
    };,
    
    // INLINE
    
    contents: [
      {
        description: {
          text: regionDescriptionProxy,
          placeholders: [placeholders.personName],
      },
    },
  ```

### Block json

- Block json can be a function if an argument is being passed.

### Variants

- Where variants exist, a question method should be used and passed the variables that control the variant, e.g. `isProxy`.
```
    {
      type: 'Question',
      id: 'date-of-birth',
      question_variants: [
        {
          question: question(nonProxyTitle),
          when: [rules.isNotProxy],
        },
        {
          question: question(proxyTitle),
          when: [rules.isProxy],
        },
      ],
    }
```