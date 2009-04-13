# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

$:.push(File.dirname(__FILE__))
require 'spec_helper'

module RightCert

  describe Serializer do
    
    include SpecHelpers

    before(:all) do
      @certificate, @key = issue_cert
      @store = StaticCertificateStore.new(@certificate, @certificate)
      @identity = "id"
      @data = "Test Data"
    end
    
    it 'should raise when not initialized' do
      lambda { Serializer.dump(@data) }.should raise_error
    end

    it 'should deserialize signed data' do
      Serializer.init(@identity, @certificate, @key, @store, false)
      data = Serializer.dump(@data)
      Serializer.load(data).should == @data
    end
    
    it 'should deserialize encrypted data' do
      Serializer.init(@identity, @certificate, @key, @store, true)
      data = Serializer.dump(@data)
      Serializer.load(data).should == @data
    end

  end

end