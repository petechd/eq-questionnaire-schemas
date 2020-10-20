local placeholders = import '../../../lib/placeholders.libsonnet';
local rules = import 'rules.libsonnet';

local questionTitle(isProxy) = (
  if isProxy then {
    text: 'What is the UK address where <em>{person_name}</em> usually stays during term time?',
    placeholders: [
      placeholders.personName(),
    ],
  } else 'What is the UK address where you usually stay during term time?'
);

local question(isProxy) = {
  id: 'term-time-address-uk-question',
  title: questionTitle(isProxy),
  type: 'General',
  answers: [
    {
      id: 'term-time-address-uk-answer',
      mandatory: false,
      type: 'Address',
      lookup_options: {
        address_type: 'Residential',
        region_code: std.extVar('region_code'),
      },
    },
  ],
};


{
  type: 'Question',
  id: 'term-time-address-uk',
  page_title: 'Term-time address UK',
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
  routing_rules: [
    {
      goto: {
        section: 'End',
      },
    },
  ],
}
