require 'helper'

describe "filesystem", Config::Project do

  subject { Config::Project.new(tmpdir) }

  describe "loading patterns" do

    before do
      (tmpdir + "patterns/project_test1").mkpath
      (tmpdir + "patterns/project_test1/pattern1.rb").open("w") do |f|
        f.puts "class ProjectTest1::Pattern1 < Config::Pattern; end"
      end
      (tmpdir + "patterns/project_test1/pattern2.rb").open("w") do |f|
        f.puts "class ProjectTest1::Pattern2 < Config::Pattern; end"
      end
      (tmpdir + "patterns/project_test2").mkpath
      (tmpdir + "patterns/project_test2/pattern1.rb").open("w") do |f|
        f.puts "class ProjectTest2::Pattern2 < Config::Pattern; end"
      end
    end

    it "loads all patterns" do
      subject.require_patterns
      assert defined?(ProjectTest1::Pattern1)
      assert defined?(ProjectTest1::Pattern2)
      assert defined?(ProjectTest2::Pattern2)
    end
  end

  describe "loading a pattern with a syntax error" do

    before do
      (tmpdir + "patterns/project_test1").mkpath
      (tmpdir + "patterns/project_test1/pattern1.rb").open("w") do |f|
        f.puts "class ProjectTest1::Pattern1"
      end
    end

    it "exposes the error" do
      proc { subject.require_patterns }.must_raise(SyntaxError)
    end
  end

  describe "loading clusters" do

    before do
      (tmpdir + "clusters").mkdir
      (tmpdir + "clusters/one.rb").open("w") do |f|
        f.puts "configure :test, :key => 123"
      end
      (tmpdir + "clusters/two.rb").open("w") do |f|
        f.puts "configure :other, :key => 456"
      end
    end

    it "loads all clusters" do
      subject.require_clusters
      subject.clusters["one"].test.key.must_equal 123
      subject.clusters["two"].other.key.must_equal 456
    end
  end

  describe "loading a cluster with a syntax error" do

    before do
      (tmpdir + "clusters").mkdir
      (tmpdir + "clusters/test.rb").open("w") do |f|
        f.puts "x, y"
      end
    end

    it "exposes the error" do
      proc { subject.require_clusters }.must_raise(SyntaxError)
    end
  end

  describe "loading blueprints" do

    before do
      (tmpdir + "blueprints").mkdir
      (tmpdir + "blueprints/one.rb").open("w") do |f|
        f.puts "file \"/tmp/file1\""
      end
      (tmpdir + "blueprints/two.rb").open("w") do |f|
        f.puts "file \"/tmp/file2\""
      end
    end

    it "loads all blueprints" do
      subject.require_blueprints
      subject.blueprints["one"].must_be_instance_of Config::Blueprint
      subject.blueprints["two"].must_be_instance_of Config::Blueprint
    end
  end

  describe "loading a blueprint with a syntax error" do

    before do
      (tmpdir + "blueprints").mkdir
      (tmpdir + "blueprints/test.rb").open("w") do |f|
        f.puts "x, y"
      end
    end

    it "exposes the error" do
      skip "this doesn't work because blueprint evaluation doesn't occur until accumulation"
      proc { subject.require_blueprints }.must_raise(SyntaxError)
    end
  end
end
