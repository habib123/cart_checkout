require 'spec_helper'

describe Checkout do
  subject { Checkout.new }

  describe 'initializing' do
    it 'with empty subtotal' do
      expect(subject.subtotal).to eq(0.0)
    end

    it 'with empty total' do
      expect(subject.total).to eq(0.0)
    end
  end

  context 'check without pricing rules' do
    let(:item) { Item.new('101', 'test_name', 20) }

    it 'subtotal as the cumulative item prices' do
      subject.scan(item)
      subject.scan(item)
      expect(subject.subtotal).to eq(40)
    end

    it 'subtotal as the item price' do
      subject.scan(item)
      expect(subject.subtotal).to eq(20)
    end

    it 'total as the cumulative item prices' do
      subject.scan(item)
      subject.scan(item)
      expect(subject.total).to eq(40)
    end

    it 'total with two decimal places' do
      item = Item.new('102', 'test_test_item_2', 20.256)
      subject.scan(item)
      expect(subject.total).to eq(20.26)
    end

    it 'total as the item price' do
      subject.scan(item)
      expect(subject.total).to eq(20)
    end
  end

  context 'Check with pricing rules' do
    let(:item) { Item.new('101', 'test', 50) }

    describe 'scanning items' do
      before do
        allow_any_instance_of(PromotionService).to receive(:price_update).and_return(30)
        subject.scan(item)
      end

      it 'ask promotion_service' do
        expect_any_instance_of(PromotionService).to receive(:price_update).with(item, 1).and_return(30)
        subject.total
      end

      it 'price from service' do
        expect(subject.total).to eq(30)
      end

      it 'check unaffected subtotal' do
        expect(subject.subtotal).to eq(50)
      end
    end

    describe 'check total discount' do
      before do
        allow_any_instance_of(PromotionService).to receive(:apply_deduction).with(50).and_return(25)
        subject.scan(item)
      end

      it 'ask promotion_service' do
        expect_any_instance_of(PromotionService).to receive(:apply_deduction).with(50).and_return(25)
        subject.total
      end

      it 'apply discount to total' do
        expect(subject.total).to eq(25)
      end
    end

    describe 'checkout many items' do
      let(:test_item_2) { Item.new('202', 'test_item_2', 40) }
      let(:test_item_3) { Item.new('303', 'test_item_3', 60) }

      before do
        subject.scan(item)
        subject.scan(test_item_2)
        subject.scan(test_item_3)

        allow_any_instance_of(PromotionService).to receive(:price_update).with(item, 1).and_return(50)
        allow_any_instance_of(PromotionService).to receive(:price_update).with(test_item_2, 1).and_return(30)
        allow_any_instance_of(PromotionService).to receive(:price_update).with(test_item_3, 1).and_return(50)
        allow_any_instance_of(PromotionService).to receive(:apply_deduction).and_return(120)
      end

      it 'ask prices from promotion_service' do
        expect_any_instance_of(PromotionService).to receive(:price_update).with(item, 1).and_return(50)
        expect_any_instance_of(PromotionService).to receive(:price_update).with(test_item_2, 1).and_return(30)
        expect_any_instance_of(PromotionService).to receive(:price_update).with(test_item_3, 1).and_return(50)

        subject.total
      end

      it 'ask total discount from promotion_service' do
        expect_any_instance_of(PromotionService).to receive(:apply_deduction).with(130).and_return(120)

        subject.total
      end

      it 'total with discount' do
        expect(subject.total).to eq(120)
      end
    end
  end
end
