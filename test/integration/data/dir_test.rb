require 'helper'

describe "filesystem", Config::Data::Dir do

  subject { Config::Data::Dir.new(tmpdir) }

  describe "#fqn" do
    it "reads the value from disk if it exists" do
      subject.fqn.must_equal nil
      (tmpdir + "fqn").open("w") { |f| f.puts "xyz" }
      subject.fqn.must_equal "xyz"
    end
  end

  describe "#ssh_key" do

    it "returns a file" do
      file = subject.ssh_key(:default)
      file.must_be_instance_of Config::Data::File
      file.path.must_equal (tmpdir + "ssh-key-default").to_s
    end
  end

  describe "#ssh_host_signature" do

    it "returns a file" do
      file = subject.ssh_host_signature("github.com")
      file.must_be_instance_of Config::Data::File
      file.path.must_equal (tmpdir + "ssh-host-github.com").to_s
    end
  end
end
