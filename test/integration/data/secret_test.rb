require 'helper'

describe "filesystem", Config::Data::Secret do

  subject { Config::Data::Secret.new(tmpdir + "mine") }

  describe "#read" do
    it "returns nil if nothing exists" do 
      subject.read.must_equal nil
    end
    it "returns the file contents" do
      (tmpdir + "mine").open("w") do |f|
        f.print "ok"
      end
      subject.read.must_equal "ok"
    end
  end
end