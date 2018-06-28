
require 'rspec/core'
require 'rspec/core/rake_task'

task default: :spec

desc 'Run all specs in spec directory (excluding plugin specs)'
RSpec::Core::RakeTask.new(:spec)

project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/lib/*') { |file| require file }

desc 'Run Cart'

task :run do

  item1 = Item.new('001', 'Curry Sauce ', 1.95)
  item2 = Item.new('002', 'Pizza', 5.99)
  item3 = Item.new('003', 'Men T-Shirt', 25.00)

  pricing_rules = []
  pricing_rules << PricingRule.new_discount_pricingrule(30, 10)
  pricing_rules << PricingRule.new_multipurchase_pricingrule('002', 3.99, 2)


  puts '################ Test Case 1: ##################'

  checkout = Checkout.new(pricing_rules)
  checkout.scan(item1)
  checkout.scan(item2)
  checkout.scan(item3)

  puts "Subtotal: #{checkout.subtotal}"
  puts "Total: #{checkout.total}"

  puts '################ Test Case  2: ################'

  checkout = Checkout.new(pricing_rules)
  checkout.scan(item2)
  checkout.scan(item1)
  checkout.scan(item2)

  puts "Subtotal: #{checkout.subtotal}"
  puts "Total: #{checkout.total}"

  puts '################ Test Case  3: ################'

  checkout = Checkout.new(pricing_rules)
  checkout.scan(item2)
  checkout.scan(item1)
  checkout.scan(item2)
  checkout.scan(item3)

  puts "Subtotal: #{checkout.subtotal}"
  puts "Total: #{checkout.total}"

end
