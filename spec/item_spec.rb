require 'spec_helper'

describe Item do
  subject { Item.new('100', 'Item Name', 1.95) }

  it 'correct item code' do
    expect(subject.code).to eq('100')
  end

  it 'correct item name' do
    expect(subject.name).to eq('Item Name')
  end

  it 'correct price of the item' do
    expect(subject.price).to eq(1.95)
  end
end
