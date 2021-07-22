# frozen_string_literal: true

require 'irb'
require 'zeitwerk'
require 'pry'

loader = Zeitwerk::Loader.new
loader.push_dir('db')
loader.push_dir('lib')
loader.push_dir('models')
loader.setup

Console.run

IRB.start
