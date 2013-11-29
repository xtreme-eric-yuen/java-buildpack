# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright (c) 2013 the original author or authors.
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
require 'component_helper'
require 'java_buildpack/util/play/post22'

describe JavaBuildpack::Util::Play::Post22 do
  include_context 'component_helper'

  before do
    java_home
    java_opts
  end

  context do

    let(:trigger) { described_class.new(application).supports? }

    it 'should not recognize non-applications' do
      expect(trigger).not_to be
    end

    it 'should not recognize Play 2.0 applications',
       app_fixture: 'container_play_2.0_dist' do

      expect(trigger).not_to be
    end

    it 'should not recognize Play 2.1 dist applications',
       app_fixture: 'container_play_2.1_dist' do

      expect(trigger).not_to be
    end

    it 'should not recognize Play 2.1 staged applications',
       app_fixture: 'container_play_2.1_staged' do

      expect(trigger).not_to be
    end

    it 'should recognize Play 2.2 applications',
       app_fixture: 'container_play_2.2' do

      expect(trigger).to be
    end

    it 'should recognize a Play 2.2 application with a missing .bat file if there is precisely one start script',
       app_fixture: 'container_play_2.2_minus_bat_file' do

      expect(trigger).to be
    end

    it 'should not recognize a Play 2.2 application with a missing .bat file and more than one start script',
       app_fixture: 'container_play_2.2_ambiguous_start_script' do

      expect(trigger).not_to be
    end
  end

  context app_fixture: 'container_play_2.2' do

    let(:play_app) { described_class.new application }

    it 'should correctly determine the version of a Play 2.2 application' do
      expect(play_app.version).to eq('2.2.0')
    end

    it 'should correctly extend the classpath' do

      play_app.compile
      expect((app_dir + 'bin/play-application').read)
      .to match 'declare -r app_classpath="\$app_home/../.additional-libraries/test-jar-1.jar:\$app_home/../.additional-libraries/test-jar-2.jar:'
    end

    it 'should return command' do
      expect(play_app.release).to eq("PATH=#{java_home}/bin:$PATH JAVA_HOME=#{java_home} $PWD/bin/play-application " +
                                         '-Jtest-opt-2 -Jtest-opt-1 -J-Dhttp.port=$PORT')
    end

  end

end
