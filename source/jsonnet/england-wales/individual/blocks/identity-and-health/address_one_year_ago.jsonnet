local placeholders = import '../../../lib/placeholders.libsonnet';
local rules = import 'rules.libsonnet';


local questionTitle(isProxy) = (
  if isProxy then {
    text: 'What was <em>{person_name_possessive}</em> address one year ago?',
    placeholders: [
      placeholders.personNamePossessive,
    ],
  } else 'What was your address one year ago?'
);

local question(isProxy) = {
  id: 'address-one-year-ago-question',
  title: questionTitle(isProxy),
  type: 'General',
  answers: [
    {
      id: 'address-one-year-ago-answer',
      mandatory: false,
      type: 'Address',
      lookup_options: {
        address_type: 'Residential',
        one_year_ago: true,
        region_code: std.extVar('region_code'),
      },
    },
  ],
};


{
  type: 'Question',
  id: 'address-one-year-ago',
  page_title: 'Address one year ago',
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
