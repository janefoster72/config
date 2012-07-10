require 'helper'

describe "filesystem", Config::ProjectData do

  subject { Config::ProjectData.new(tmpdir) }

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

  describe "#accumulation" do

    it "returns nil if no file exits" do
      subject.accumulation.must_equal nil
    end

    it "reads from a file" do
      a = Config::Core::Accumulation.new([1, 2, 3])
      (tmpdir + "accumulation.marshall").open("w") { |f| f.print Marshal.dump(a) }
      b = subject.accumulation
      a.must_equal b
    end
  end

  describe "#accumulation=" do

    it "writes a file" do
      subject.accumulation = Config::Core::Accumulation.new([1, 2, 3])
      (tmpdir + "accumulation.marshall").must_be :exist?
    end
  end

  describe "#remotes" do

    it "returns nil if no file exists" do
      subject.remotes.must_equal nil
    end

    it "reads from a file" do
      (tmpdir + "remotes.yml").open("w") do |f|
        f.puts ""
      end
      subject.remotes.wont_equal nil
    end
  end

  describe "#remotes=" do

    it "writes a file" do
      subject.remotes = Config::Core::Remotes.new
      (tmpdir + "remotes.yml").must_be :exist?
    end
  end
end
