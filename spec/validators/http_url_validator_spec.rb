require 'rails_helper'

describe HttpUrlValidator, type: :validator do
  before { @validator = HttpUrlValidator.new attributes: { url: '' } }

  context 'invalid url input' do
    it 'should return false for a badly formed URL' do
      expect(@validator.url_valid?('something.com')).to be_falsey
    end

    it 'should return false for garbage input' do
      url = '12sdw21'
      expect(@validator.url_valid?(url)).to be_falsey
    end

    it 'should return false for URLs without an HTTP protocol' do
      expect(@validator.url_valid?('ftp://file.net')).to be_falsey
    end
  end

  context 'valid url input' do
    it 'should return true for a correctly formed HTTP URL' do
      expect(@validator.url_valid?('http://nodf.com')).to be
    end

    it 'should return true for a correctly formed HTTPS URL' do
      expect(@validator.url_valid?('https://google.com')).to be
    end
  end

end
