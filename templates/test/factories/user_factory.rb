# == Schema Information
# Schema version: 20090923223616
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)     not null
#  email               :string(255)     not null
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  last_login_at       :datetime
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

Factory.define :user do |u|
  u.password "success"
  u.password_confirmation { |a| a.password }
  u.created_at { Time.now.to_s(:db) }
  u.updated_at { Time.now.to_s(:db) }
  u.email { Faker::Internet.email }
  u.login { Faker::Internet.user_name }
  u.single_access_token { Authlogic::Random.hex_token }
  u.perishable_token {Authlogic::Random.friendly_token}
  u.persistence_token {Authlogic::Random.hex_token}
  u.last_login_ip { "127.0.0.1" }
  u.last_login_at { (1..10).to_a.rand.weeks.ago }
end
