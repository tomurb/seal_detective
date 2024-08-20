# frozen_string_literal: true

require "test_helper"
require "seal_detective/messages"
require "seal_detective/decorator"

module SealDetective
  Klass1 = Class.new
  Klass2 = Class.new
  describe Messages do
    before do
      Messages.instance.clean
    end
    describe ".add" do
      it "adds new record to instances' array" do
        kwargs = { sender: Klass1, receiver: Klass2, method: :abc, arguments: [[1], { b: 2 }, nil] }

        Messages.add(**kwargs)

        assert_equal([**kwargs], Messages.instance.send(:array).map(&:to_h))
      end
    end

    describe "#clean" do
      it "empties the array" do
        Messages.add(sender: "sender", receiver: "receiver", method: :method, arguments: [])
        Messages.instance.clean
        assert_empty(Messages.instance.array)
        assert_equal(Messages.instance.array, [])
      end
    end
    describe "#format" do
      arguments = [1, { b: 2 }]
      it "handles single message" do
        Messages.add(sender: Klass1, receiver: Klass2, method: :method1, arguments: arguments)
        Messages.add(sender: Klass2, receiver: Klass1, method: :method2, arguments: arguments)

        assert_equal(
          Messages.instance.format,
          ["SealDetective::Klass1->SealDetective::Klass2:method1[1, {:b=>2}]",
           "SealDetective::Klass2->SealDetective::Klass1:method2[1, {:b=>2}]"]
        )
      end
      # it "creates participants" - should be done by printer/sequencediagram.com
      # ? it "handles non instantaneous messages"
      # it "handles failures"
      # it "handles creation" # <<create>>
      # it "handles loops"
    end
  end
end
