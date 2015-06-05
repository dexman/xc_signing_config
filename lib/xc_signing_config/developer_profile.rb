require 'zip'

module XCSigningConfig
  class DeveloperProfile
    def initialize(path:)
      @zip = Zip::File.open(path)
    end

    def close
      @zip.close
    end

    def each_identity
      @zip.glob('developer/identities/*.p12') do |entry|
        yield File.basename(entry.name), entry.get_input_stream.read
      end
    end

    def each_provisioning_profile
      @zip.glob('developer/profiles/*.mobileprovision') do |entry|
        yield File.basename(entry.name), entry.get_input_stream.read
      end
    end

    class << self
      Zip.warn_invalid_date = false

      def open(path:)
        profile = DeveloperProfile.new(path: path)
        begin
          yield profile
        ensure
          profile.close
        end
      end
    end

    private

    attr_reader :zip
  end
end

