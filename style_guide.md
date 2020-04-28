# Jsonnet Style Guide
This style guide documents how we want to handle Jsonnet files when building questionnaire schemas with consistency. For more general principles and styling rules go to [Databricks repository](https://github.com/databricks/jsonnet-style-guide#databricks-jsonnet-guide).

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
  
- We currently have the following questionnaires:

    - `ccs`
    - `communal-establishment`
    - `household`
    - `individual`

- Blocks from the `individual` folder are also used from the `household` questionnaire.

## Global variables

- Global variables are variables known at questionnaire launch. They don't change during completion of a questionnaire.
- Top-level arguments (`--tla-str`) are used to pass variables that are used in 5 blocks or less.
- External variables (`--ext-str`) are used to pass variables that are used in a more than 5 blocks.
  - External variables are used for `census_date` and `region_code`.
  - Example of an external variable in `answers`:
    
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

- Block json can be a function if an argument is being passed:

    ```
    function(census_month_year_date) {
      type: 'Question',
      id: 'arrive-in-country',
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
  
### Variants

- When the value of a property needs to vary, a method should be defined that returns an appropriate value.

#### Single value variants example
- The most common approach in census schemas is to create variants based on a value of a single variable:
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
    };

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
  
    local questionTitle(isProxy) = (
      if isProxy then 
        {
          text: 'What was <em>{person_name_possessive}</em> age on their last birthday?',
          placeholders: [
            placeholders.personNamePossessive,
        ]} 
      else 'What was your age on your last birthday?';
    );
    ```
- The `isProxy` variable is passed to the `question` method.
- The `question` method calls `questionTitle(isProxy)` to resolve the question title.
- `questionTitle` returns the appropriate JSON for title.

- Same rules apply to other blocks with variants, e.g. for guidance with a `questionGuidance` method we would use:
    ```
    local questionGuidance(isProxy) = (
      if isProxy then 
        'Why we ask this question if they are retired or long-term sick or disabled' 
      else 'Why we ask this question if you are retired or long-term sick or disabled';
    );
    ```
#### Multiple value variants example

- There are occasions where more than one variable is used to create variants. Example of this would be a `Question` block using combination of `isProxy` and `isEmployed` variables:

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
    };
  
    local question(isProxy, isEmployed) = {
      id: 'business-name-question',
      title: questionTitle(isProxy, isEmployed),
      description: description,
      type: 'MutuallyExclusive',
      mandatory: false,
      answers: [
        {
          id: 'business-name-answer',
          label: 'Organisation or business name',
          max_length: 160,
          mandatory: false,
          type: 'TextField',
        },
        {
          id: 'no-business-name-answer',
          mandatory: false,
          type: 'Checkbox',
          options: [
            {
              label: option,
              value: option,
            },
          ],
        },
      ],
    };
  
    local questionTitle(isProxy, isEmployed) = (
      if isEmployed then (
        if isProxy then 
          {
            text: 'What is the main activity of <em>{person_name_possessive}</em> organisation, business or freelance work?',
            placeholders: [
              placeholders.personNamePossessive,
            ]
          }
        else 'What is the main activity of your organisation, business or freelance work?'
      ) else (
        if isProxy then 
          {
            text: 'What was the main activity of <em>{person_name_possessive}</em> organisation, business or freelance work?',
            placeholders: [
              placeholders.personNamePossessive,
            ]
          }
        else 'What was the main activity of your organisation, business or freelance work?';
      )
    );
    ```
- The `isProxy` and `isEmployed` variables are passed to the `question` method.
- The `question` method calls `questionTitle(isProxy, isEmployed)` to resolve the question title.
- `questionTitle` returns the appropriate JSON for title.

- Same rules apply to other blocks, e.g. for guidance with a `questionGuidance` method we would use:
    ```
    local guidance(isProxy) = (
      if std.extVar('region_code') == 'GB-WLS' then
        if isProxy then
          walesGuidanceProxy else walesGuidanceNonProxy
      else if isProxy then englandGuidanceProxy else englandGuidanceNonProxy
    );
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
