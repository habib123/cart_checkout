My implementation includes four class they are followings:
1.	Checkout - responsible to scan each item and gives the actual or reduced price based on promotion rule.
2.	Promotion Service – includes two methods, one of them update individual price based on purchasing quantity, another is accountable to calculate the discounted price based on overall buying price.
3.	Pricing rule – It has two type of pricing rule. One is multi-purchase discount which is used to determine how many purchase of products can lead to reduced price, another is implemented to define the discount on overall purchase price  
4.	Item – is to initialize an item with the properties of code, name, price.

Based on the task requirement, I came to some key decisions for implementation.
•	Checkout and item objects are independent for creating a list of items. It can easily be extended
•	Promotion service is flexible to iterate for all type of promotion rules. It encapsulates the discount and reduced price logic.
•	Addition of Items and pricing rules is done though item and pricing rule object independently.

How to add product:

Item = Item.new('002', 'Pizza', 5.99)
Here,
Code: ‘002’, Product Name: ‘Pizza’, Price: 5.99
For adding another item, it needs to create another item object as above.

How to add rule:

Basically i consider 2 type of pricing rule -

•	Pricing rule for multiple product purchasing
pricing_rules <<  PricingRule.new_multipurchase_pricingrule('002', 3.99, 2)
here,
code: 002 , price: 3.99 and quantity is 2
it determines if someone buy the product (002) more than or equal quantity 2 then the price drops to 3.99   

•	Pricing rule for discount on purchasing price
pricing_rules << PricingRule.new_discount_pricingrule(30, 10)
Here,
Total minimum purchasing price is 30 and 10 is the percentage of discount
If the purchasing price is more or equal to 30 then he will get 10% discount on his purchasing price.

To run the implementation, use the following commend
$ bundle install
$ rake run
Tests
$ rake spec
