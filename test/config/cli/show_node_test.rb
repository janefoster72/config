require 'helper'

describe Config::CLI::ShowNode do

  subject { Config::CLI::ShowNode }

  specify "#usage" do
    cli.usage.must_equal "test-command [<fqn>]"
  end

  describe "#parse" do
    it "gets the fqn from the args" do
      cli.parse! %w(a-b-c)
      cli.fqn.must_equal "a-b-c"
    end
    it "falls back to the data dir's fqn" do
      data_dir.expect(:fqn, "a-b-c")
      cli.parse!
      cli.fqn.must_equal "a-b-c"
    end
    it "fails if no fqn is available" do
      data_dir.expect(:fqn, nil)
      expect_fail_with_usage { cli.parse! }
    end
  end

  describe "#execute" do

    let(:node) { Config::Node.new("a", "b", "c") }

    before do
      node.facts = Config::Core::Facts.new(
        "ec2" => {
          "public_ipv4" => "127.0.0.1",
          "other" => ["a", "b", "c"]
        }
      )
      cli.fqn = "a-b-c"
      project.expect(:update_database, nil)
      project.expect(:get_node, node, ["a-b-c"])
    end

    it "gets all node data" do
      cli.path = nil
      cli.execute
      stdout.string.must_equal <<-STR
{
  "node": {
    "cluster": "a",
    "blueprint": "b",
    "identity": "c"
  },
  "facts": {
    "ec2": {
      "public_ipv4": "127.0.0.1",
      "other": [
        "a",
        "b",
        "c"
      ]
    }
  }
}
      STR
    end

    it "gets node data at a subpath" do
      cli.path = "ec2"
      cli.execute
      stdout.string.must_equal <<-STR
{
  "public_ipv4": "127.0.0.1",
  "other": [
    "a",
    "b",
    "c"
  ]
}
      STR
    end

    it "gets node data at a leaf" do
      cli.path = "ec2.public_ipv4"
      cli.execute
      stdout.string.must_equal <<-STR
127.0.0.1
      STR
    end

  end
end


