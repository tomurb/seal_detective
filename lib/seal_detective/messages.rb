# frozen_string_literal: true

require "singleton"

module SealDetective
  Record = Data.define(:sender, :receiver, :method, :arguments) do
    def to_s # TODO: change, this is just for debugging
      {
        sender: sender,
        receiver: receiver,
        method: method,
        arguments: arguments
      }
    end
  end

  # TODO: it should not be a singleton, should create a class that would have a
  # method taking block, which at the end would persist the data - good for memory consumption
  #   def something
  #     create_array
  #     yield - add items to the array
  #     can i force everything in block to know some variable?
  #     * frist caller? - it would not be heavy, it would check first element in the stack, I guess
  #     print_array
  #     clean_array
  #   end
  #   1. Message#to_s
  #   2. Messages#to_s
  #   3. Persistance
  #   4. Resetting state after test example
  class Messages
    include ::Singleton

    def self.add(**kwargs)
      # puts "debtu add", instance.array.size
      record = Record.new(**kwargs)
      instance.array << record
    end

    def to_sequence_diagram
      array.map(&:to_s)
    end

    def format
      array.map do |record|
        record => {sender:, receiver:, method:, arguments:}
        "#{sender}->#{receiver}:#{method}#{arguments}"
      end
    end

    def clean
      @array = []
    end

    def array
      @array ||= []
    end
  end
end
