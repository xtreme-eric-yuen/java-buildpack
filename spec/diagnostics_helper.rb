# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright 2013 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'
require 'application_helper'
require 'console_helper'
require 'fileutils'
require 'java_buildpack/diagnostics'
require 'java_buildpack/diagnostics/logger_factory'

shared_context 'diagnostics_helper' do
  include_context 'console_helper'
  include_context 'application_helper'

  previous_log_level = ENV['JBP_LOG_LEVEL']
  previous_debug_level = $DEBUG
  previous_verbose_level = $VERBOSE

  let(:diagnostics_dir) { Pathname.new(JavaBuildpack::Diagnostics.get_diagnostic_directory application) }

  let(:log_contents) { Pathname.new(JavaBuildpack::Diagnostics.get_buildpack_log application).read }

  let(:logger) { JavaBuildpack::Diagnostics::LoggerFactory.create_logger application }

  before do |example|
    log_level = example.metadata[:log_level]
    ENV['JBP_LOG_LEVEL'] = log_level if log_level

    $DEBUG = example.metadata[:debug]
    $VERBOSE = example.metadata[:verbose]

    logger
  end

  after do
    JavaBuildpack::Diagnostics::LoggerFactory.close

    ENV['JBP_LOG_LEVEL'] = previous_log_level
    $VERBOSE = previous_verbose_level
    $DEBUG = previous_debug_level
  end

end
