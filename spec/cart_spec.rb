require 'spec_helper'

describe Cart do
	it { should belong_to :checkout }
	it { should belong_to :purchase }
end
