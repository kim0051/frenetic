describe Frenetic::Configuration do
  let(:yaml_config) {
    { 'test' => {
        'url'     => 'http://example.org',
        'api_key' => '1234567890',
        'version' => 'v2'
      }
    }
  }
  let(:config) { Frenetic::Configuration.new( unknown: :option ) }

  subject { config }

  describe ".configuration" do
    include FakeFS::SpecHelpers

    context "with a proper config YAML" do
      before do
        FileUtils.mkdir_p("config")
        File.open( 'config/frenetic.yml', 'w') do |f|
          f.write( YAML::dump(yaml_config) )
        end
      end

      it { should include(:user) }
      it { should include(:accepts) }
      it { should include(:url) }
      it { should_not include(:unknown => 'option')}
    end

    context "with no config YAML" do
      context "and no passed options" do
        it "should raise a configuration error" do
          expect { Frenetic::Configuration.new }.to raise_error( Frenetic::Configuration::ConfigurationError )
        end
      end
      context "and passed options" do
        let(:config) { Frenetic::Configuration.new( 'url' => 'http://example.org' ) }

        it { should be_a( Hash ) }
        it { should_not be_empty }
      end
    end
  end

end