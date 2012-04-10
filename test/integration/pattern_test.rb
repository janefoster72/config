describe Config::Pattern do

  let(:pattern_class) {
    Class.new(Config::Pattern) do

      # give this temporary class a name.
      def self.name; "TheClass" end

      desc "The name"
      key :name

      desc "The value"
      attr :value

      def call
        add self.class do |x|
          x.name = "sub-#{name}"
          x.value = "sub-#{value}"
        end
      end

      attr_reader :result

      def create
        @result = "created"
      end

      def destroy
        @result = "destroyed"
      end
    end
  }

  let(:accumulation) { Config::Core::Accumulation.new }

  subject { pattern_class.new(accumulation) }

  before do
    subject.name = "test"
    subject.value = 123
  end

  it "has a useful #to_s" do
    subject.to_s.must_equal "TheClass name:test"
  end

  describe "#call" do

    before do
      subject.call
    end

    let(:child_pattern) { accumulation.to_a.first }

    it "accumulates the child patterns" do
      accumulation.size.must_equal 1
    end
    it "assigns itself to the child pattern" do
      child_pattern.parent.must_equal subject
    end
    it "configures the child pattern" do
      child_pattern.name.must_equal "sub-test"
      child_pattern.value.must_equal "sub-123"
    end
  end

  describe "#execute" do

    it "creates by default" do
      subject.execute
      subject.result.must_equal "created"
    end
    it "creates" do
      subject.run_mode = :create
      subject.execute
      subject.result.must_equal "created"
    end
    it "destroys" do
      subject.run_mode = :destroy
      subject.execute
      subject.result.must_equal "destroyed"
    end
    it "does nothing" do
      subject.run_mode = :noop
      subject.execute
      subject.result.must_equal nil
    end
  end
end