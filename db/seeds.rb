require 'university/mail_university_hash_generator'
require 'university/university_country'
require 'sports/sports_hash_generator'

# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db
# with db:setup).


if UniversityMail.count == 0
  universities_hash = MailUniversityHashGenerator.generate_mail_university_hash(
                        UniversityCountry::ENGLAND)
  universities_hash.each do |name, population|
    UniversityMail.create(mail_extension: name, university_name: population)
  end
end

if Sport.count == 0
  sports_hash = SportsHashGenerator.generate_sports_hash()
  sports_hash.each do |name, _|
    Sport.create(name: name)
  end
end
