# frozen_string_literal: true

require "test_helper"

require "seal_detective/decorator"

module SealDetective
  describe Decorator do
    describe "including" do
      describe "class methods" do
        it "after including method works the same" do
          klass = Class.new
          def klass.bar
            "original return value"
          end

          klass.include(Decorator)

          assert_equal("original return value", klass.bar)
        end
        it "methods after inclusion take the same arguments" do
          klass1 = Class.new
          def klass1.foo(a, b:)
            [a, b, yield]
          end

          klass1.include(Decorator)

          assert_equal([1, 2, 3], klass1.foo(1, b: 2) { 3 })

          klass2 = Class.new
          def klass2.foo(a:)
            a
          end

          klass2.include(Decorator)

          assert_equal(4, klass2.foo(a: 4))
        end
        it "Sends Messages.add with proper arguments" do
          receiver = Class.new
          def receiver.bar(a, b:, &c); end
          receiver.include(Decorator)

          messages_mock = Minitest::Mock.new
          messages_mock.expect(:add, nil, sender: self, receiver: receiver, method: :bar,
                                          arguments: [[1], { b: 1 }, nil])

          SealDetective.stub_const(:Messages, messages_mock) do
            receiver.bar(1, b: 1)
          end

          messages_mock.verify
        end
      end
      describe "instance methods" do
        it "after including method works the same" do
          klass = Class.new do
            def bar
              "original return value"
            end
          end

          klass.include(Decorator)

          assert_equal("original return value", klass.new.bar)
        end
        it "methods after inclusion take the same arguments" do
          klass1 = Class.new do
            def foo(a, b:)
              [a, b, yield]
            end
          end

          klass1.include(Decorator)

          assert_equal([1, 2, 3], klass1.new.foo(1, b: 2) { 3 })

          klass2 = Class.new do
            def foo(a:)
              a
            end
          end

          klass2.include(Decorator)

          assert_equal(4, klass2.new.foo(a: 4))
        end
        it "Sends Messages.add with proper arguments" do
          receiver = Class.new do
            def bar(a, b:, &c); end
          end
          receiver.include(Decorator)
          receiver_instance = receiver.new

          messages_mock = Minitest::Mock.new
          messages_mock.expect(:add, nil, sender: self, receiver: receiver_instance, method: :bar,
                                          arguments: [[1], { b: 1 }, nil])

          SealDetective.stub_const(:Messages, messages_mock) do
            receiver_instance.bar(1, b: 1)
          end

          messages_mock.verify
        end
      end
    end
  end
end
