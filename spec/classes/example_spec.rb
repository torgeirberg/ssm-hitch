require 'spec_helper'

describe 'hitch' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "hitch class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('hitch::params') }
          it { is_expected.to contain_class('hitch::install').that_comes_before('hitch::config') }
          it { is_expected.to contain_class('hitch::config') }
          it { is_expected.to contain_class('hitch::service').that_subscribes_to('hitch::config') }

          it { is_expected.to contain_service('hitch') }
          it { is_expected.to contain_package('hitch').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'hitch class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('hitch') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end