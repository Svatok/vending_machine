# frozen_string_literal: true

require 'irb'
require 'zeitwerk'
require 'i18n'
require 'pry'

I18n.load_path << Dir["#{File.expand_path('config/locales')}/*.yml"]
loader = Zeitwerk::Loader.new
loader.push_dir('db')
loader.push_dir('lib')
loader.push_dir('models')
loader.setup
