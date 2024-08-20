# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "seal_detective"

require "minitest/autorun"
require "minitest/mock"
require "minitest/stub_const"

require "minitest/spec"
Minitest::Test.include(Minitest::Spec::DSL)
