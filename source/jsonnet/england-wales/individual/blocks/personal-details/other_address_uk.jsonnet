local placeholders = import '../../../lib/placeholders.libsonnet';
local rules = import 'rules.libsonnet';

local questionTitle(isProxy) = (
  if isProxy then {
    text: 'What is the other UK address where <em>{person_name}</em> stays for more than 30 days a year?',
    placeholders: [
      placeholders.personName(),
    ],
  } else 'What is the other UK address where you stay for more than 30 days a year?'
);

local question(isProxy) = {
  id: 'other-address-uk-question',
  title: questionTitle(isProxy),
  type: 'General',
  answers: [
    {
      id: 'other-address-uk-answer',
      mandatory: true,
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
  id: 'other-address-uk',
  page_title: 'Other UK address',
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
