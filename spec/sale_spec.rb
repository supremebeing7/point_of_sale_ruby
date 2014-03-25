require 'spec_helper'

describe Sale do
  it { should have_many :purchases }
end
