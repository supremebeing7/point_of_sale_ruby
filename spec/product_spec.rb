require 'spec_helper'

describe Product do
  it {should have_many :purchases}
end
