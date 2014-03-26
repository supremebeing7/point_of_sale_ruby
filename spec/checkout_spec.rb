require 'spec_helper'

describe Checkout do
  it { should have_many :carts }
  it { should have_many :purchases }
  it { should belong_to :cashier }
end
