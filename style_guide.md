# Jsonnet Style Guide
This style guide documents how we want to handle Jsonnet files when building the schemas with consistency. For more general principles and styling rules go to [Databricks repository](https://github.com/databricks/jsonnet-style-guide#databricks-jsonnet-guide).

## Folder structure
- The following structure is used:

    ```
    england-wales/
       lib/
          common_rules.libsonnet
          placeholders.libsonnet
       <questionnaire>/
          <questionniare>.jsonnet
          lib/
             rules.libsonnet
          blocks/
             <section-one>/
                <block-one>.jsonnet
                <block-two>.jsonnet
             <section-two>/
    northern-ireland/   
    ```
- Jsonnet source files are separated into two top-level folders - `england-wales` and `northern-ireland` 
- The `lib/` folder contains common Jsonnet used across all questionnaire schemas
  - The file extension should be `.libsonnet`
  - Each file is grouped by function, currently `common_rules` and `placeholders`
- Each questionnaire has it's own folder, within this:
  - A top-level questionnaire definition Jsonnet file 
  - A `lib/` folder holds common Jsonnet used across multiple blocks
    - The file extension should be `.libsonnet`
    - Each file here can extend common Jsonnet from the questionnaire level lib folder
    - `rules.libsonnet` extends the top level `lib/common_rules.libsonnet`
  - A `blocks` folder:
    - Subdivided into section folders
    - Within each section folder a Jsonnet file per block
  
We currently have the following questionnaires:

- `ccs`
- `communal-establishment`
- `household`
- `individual`

Blocks from the `individual` folder are also used from the `household` questionniare.

## Global variables

- Top level arguments
    
    - Top-level arguments (`--tla-str`) are used to pass variables that are used in 5 blocks or less.
    - For each schema created it is possible to pass variables, e.g.: `region_code` and `census_month_year_date`, with different outputs being generated depending on their value.
    - These are defined in eq-questionnaire-runner, are known at questionnaire launch and won't change during the Census.

- External variables
    
    - External variables (`--ext-str`) are used to pass variables that are used in a more than 5 blocks.
    - External variables are being used. Example of that is `census_month_year_date` and `region_code`.
    - Example of how we use external variable in `answers`:
    
        ```
        answers: [
          {
            id: 'date-of-birth-answer',
            mandatory: true,
            type: 'Date',
            minimum: {
              value: std.extVar('census_date'),
              offset_by: {
                years: -115,
                months: -2,
                days: -20,
              },
            },
            maximum: {
              value: 'now',
            },
          },
        ],
        ```
    

- Region Code
    - Depending on its value, different structure of sections is generated (e.g. certain questions omitted).
    - Because it's an external variable now, it doesn't have to be passed to blocks and would align with how we use `census_date`.
    - Example of how we determine if Welsh or English description is used:
      ```
      local radioOptions = (
        if std.extVar('region_code') == 'GB-WLS' then 'Welsh, English, Scottish, Northern Irish or British'
        else 'Welsh, English, Scottish, Northern Irish or British';
      );
      ```


## Blocks

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
### Variants

- Any time we want to vary the value of a property in a variant of question or content, a method needs to be defined that returns the appropriate variant.
- Currently for variants we use mainly `isProxy` variable but also job and age related ones: `isEmployed`, `over16`, `over19`, `under19`.
- Example of question(isProxy=true) and question(isProxy=false) variants:
    ```
    {
      type: 'Question',
      id: 'confirm_dob',
      question_variants: [
        {
          question: question(isProxy=false),
          when: [rules.isNotProxy],
        },
        {
          question: question(isProxy=true),
          when: [rules.isProxy],
        },
      ],
    }
    ```
- Variants using combination of `isProxy` and `isEmployed`:

    ```
    {
      type: 'Question',
      id: 'business-name',
      question_variants: [
        {
          question: question(isProxy=false, isEmployed=true),
          when: [rules.isNotProxy, rules.isEmployed],
        },
        {
          question: question(isProxy=true, isEmployed=true),
          when: [rules.isProxy, rules.isEmployed],
        },
        {
          question: question(isProxy=false, isEmployed=false),
          when: [rules.isNotProxy, rules.isNotEmployed],
        },
        {
          question: question(isProxy=true, isEmployed=false),
          when: [rules.isProxy, rules.isNotEmployed],
        },
      ],
    }
    ```
- In the question method, when we need to resolve title, we call a new questionTitle method, passing `isProxy`:
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
- In the `questionTitle` method we would return either of the two strings, based on the `isProxy` variable:
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
- Example of `questionTitle` with multiple variables:
    ```
    local questionTitle(isProxy, isEmployed) = (
      if isProxy == true && isEmployed == true then {
      text: 'What is the main activity of <em>{person_name_possessive}</em> organisation, business or freelance work?',
      placeholders: [
        placeholders.personNamePossessive,
      ]}
      else if isProxy == false && isEmployed == true then {
      text: 'What is the main activity of <em>{person_name_possessive}</em> organisation, business or freelance work?',
      placeholders: [
        placeholders.personNamePossessive,
      ]}
      else if isProxy == true && isEmployed == false then 'What was the main activity of your organisation, business or freelance work?'
      else {
      text: 'What was the main activity of <em>{person_name_possessive}</em> organisation, business or freelance work?',
      placeholders: [
        placeholders.personNamePossessive,
      ]};
    );  
    ```
- We would then do a similar thing for guidance with a questionGuidance method:
    ```
    local questionGuidance(isProxy) = (
      if isProxy == true then 'Why we ask this question if they are retired or long-term sick or disabled' else 'Why we ask this question if you are retired or long-term sick or disabled';
    );
    ```
### Block json

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

### Methods

- We should define a method each time we’re changing a property.
- Methods can be invoked at top-level or declared inline, depending on the intended use:

    ```
    // TOP-LEVEL
        
    local guidance(region_code, isProxy) = (
      if region_code == 'GB-WLS' then
        if isProxy then walesGuidanceProxy else walesGuidanceNonProxy
      else if isProxy then englandGuidanceProxy else englandGuidanceNonProxy
    );
    
    // INLINE (using region_code as top level argument, not external variable)
    
    local understandWelshBlock(region_code) = if region_code == 'GB-WLS' then [understand_welsh] else [];
    ```
### Routing

- Default routing rule is used in every block, even if the succeeding block is the target. It makes the rules easier to understand:
    ```
    routing_rules: [
      {
        goto: {
          block: 'main-employment-block',
        },
      },
    ],
    ```
