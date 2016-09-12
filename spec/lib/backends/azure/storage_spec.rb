require 'spec_helper'

describe Backends::Azure::Storage do
  let(:dalli) { Dalli::Client.new }
  let(:dummy_w_opts) do
    opts = Hashie::Mash.new
    opts.fixtures_dir = Rails.application.config.rocci_server_etc_dir.join('backends', 'azure', 'fixtures')
    Backends::Azure::Storage.new nil, opts, nil, nil, dalli
  end

  before(:each) { dalli.flush }
  after(:all) { Dalli::Client.new.flush }

  describe '#new' do
    it 'fails to instantiate without a fixtures_dir' do
      expect { Backends::Azure::Storage.new nil, nil, nil, nil, dalli }.to raise_error
    end
  end
end
