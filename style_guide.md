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
- England/Wales and Northern Ireland

    - Jsonnet source files are separated into two folders: `england-wales` and `northern-ireland` with a number of sub-folders, each for corresponding schemas (e.g. `ccs`, `communal-establishment`, `household`, `individual`). These are divided into blocks in `blocks` folder.

- Shared blocks

    - Blocks from `individual` folder are used in both household and individual schema.

- Top level Jsonnet files

    - For each schema there are lists of block and placeholder imports.
    - Schema structure is divided into sections, named after given schema and ending with `.jsonnet` suffix.

- Lib folders

    - Rules and placeholders are located in `lib` folder in corresponding schemas along with `blocks` folder.

- Rules and placeholders

    - These are separated into: `common_rules`, `placeholders` and `rules`. These files should end with `.libsonnet` suffix.

- Top level and extended

    - `common_rules` and `placeholders` are located in top-level "lib" folder.
    - `rules` files for each schema are located in schema's sub-folder and extend some of the top-level `common_rules`.

## Global variables

- Top level arguments

    - For each schema created it is possible to pass variables, e.g.: `region_code` and `census_month_year_date`, with different outputs being generated depending on their value.
    - These are defined in eq-questionnaire-runner, are known at questionnaire launch and won't change during the Census.

- External variables

    - External variables are being used. Example of that is `census_month_year_date`.

- Region Code

    - Depending on `region_code` variable's value, different structure of sections is generated (e.g. certain questions omitted).

## Blocks

### Structure

#### Block json
- There are two distinct styles we use with block json:
  - Simple (no variants):
    ```
    // Imports
    
    {
      // Block JSON
    }
    ```
  - Variants:
    ```
    // Imports
    
    // Variant helper methods
    local questionTitle(variantParam) = (
      // Variables relevant to this method
      // Return relevant string or JSON object
    );
    
    // Main variant method - 'question' or 'content'
    local question(variantParam) = {
      // Variant JSON
    };
    
    {
      // Block JSON
    }
    ```
- Question should be called with question(isProxy=true) or question(isProxy=false):
```
{
  type: 'Question',
  id: 'confirm_dob',
  question_variants: [
    {
      question: question(isProxy=false)
    },
    {
      question: question(isProxy=true)
    },
  ],
}
```
- In the question method, when we need to resolve title, we call a new questionTitle method, passing isProxy:
```
local question(isProxy) = {
  title: questionTitle(isProxy)
  id: 'confirm-date-of-birth',
  title: title,
  type: 'General',
  answers: [
  {
    id: 'confirm-date-of-birth-answer',
    mandatory: true,
    options: [
      {
        label: 'Yes',
        value: 'Yes',
       },
      {
        label: 'No',
        value: 'No',
      },
    ],
    type: 'Radio',
    },
  ],
};

```
- In the questionTitle method we would return either of the two strings, based on the isProxy variable:
```
local questionTitle(isProxy) = (
  if isProxy == true then {
  text: 'What was <em>{person_name_possessive}</em> age on their last birthday?',
  placeholders: [
    placeholders.personNamePossessive,
  ]} 
  else 'What was your age on your last birthday?';
);

```
- We would then do a similar thing for guidance with a questionGuidance method:
```
local questionGuidance(isProxy) = (
  if isProxy == true then 'Why we ask this question if they are retired or long-term sick or disabled' else 'Why we ask this question if you are retired or long-term sick or disabled';
);

```
    

- Block json can be a function if an argument is being passed:

```
function(region_code, census_month_year_date) {
  type: 'Question',
  id: 'arrive-in-country',
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

#### Methods

- We should define a method each time we’re changing a property.
- Methods can be invoked at top-level or declared inline, depending on the intended use:
```
// TOP-LEVEL
    
local guidance(region_code, isProxy) = (
  if region_code == 'GB-WLS' then
    if isProxy then walesGuidanceProxy else walesGuidanceNonProxy
  else if isProxy then englandGuidanceProxy else englandGuidanceNonProxy
);

// INLINE

local radioOptions = if region_code == 'GB-WLS' then walesOption else englandOption;

  ```

### Variants

- Where variants exist, a question method should be used and passed the variables that control the variant, e.g. `isProxy`.
```
{
  type: 'Question',
  id: 'date-of-birth',
  question_variants: [
    {
      question: question(isProxy=false)
    },
    {
      question: question(isProxy=true)
    },
  ],
}
```
