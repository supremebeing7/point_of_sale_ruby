require 'spec_helper'

describe Checkout do
  it { should have_many :carts }
  it { should have_many :purchases }
end
