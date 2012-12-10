# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Domain.create(name: 'example.org')
User.create(name: 'postmaster', domain_id: Domain.first.id, password: 'morepasta!', role: 'superadmin')
