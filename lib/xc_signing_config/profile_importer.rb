module XCSigningConfig
  class ProfileImporter
    def initialize(keychain:, profile:, profile_passphrase:)
      @keychain = keychain
      @profile = profile
      @profile_passphrase = profile_passphrase
    end

    def import
      import_identities
      import_provisioning_profiles
    end

    class << self
      def import(keychain:, profile:, profile_passphrase:)
        instance = new(
          keychain: keychain,
          profile: profile,
          profile_passphrase: profile_passphrase)
        instance.import
      end
    end

    private

    attr_reader :keychain, :profile, :profile_passphrase

    def import_identities
      profile.each_identity do |name, identity|
        keychain.import_data(
          data: identity,
          format: 'pkcs12',
          passphrase: profile_passphrase,
          allowed_applications: ['/usr/bin/codesign'])
      end
    end

    def import_provisioning_profiles
      profile.each_provisioning_profile do |name, provisioning_profile|
        File.write(
          File.join(provisioning_profiles_path, name),
          provisioning_profile)
      end
    end

    def provisioning_profiles_path
      File.expand_path('~/Library/MobileDevice/Provisioning Profiles/')
    end
  end
end
