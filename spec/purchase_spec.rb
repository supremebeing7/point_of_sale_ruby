require 'spec_helper'

describe Purchase do
  it { should belong_to :product }
  it { should have_many :carts }
end
