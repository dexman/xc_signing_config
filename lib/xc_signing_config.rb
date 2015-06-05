require 'xc_signing_config/developer_profile'
require 'xc_signing_config/keychain'
require 'xc_signing_config/profile_importer'

module XCSigningConfig
  module_function

  def use_developer_profile(path:, passphrase:)
    # Create a new keychain with random name and password
    keychain_name = SecureRandom.uuid
    keychain_password = SecureRandom.uuid
    keychain = Keychain.create(
      name: keychain_name,
      password: keychain_password)

    begin
      # Unlock keychain for 10 minutes
      keychain.unlock
      keychain.set_timeout(seconds: 600)

      # Import identities and provisioning profiles
      DeveloperProfile.open(path: path) do |profile|
        ProfileImporter.import(
          keychain: keychain,
          profile: profile,
          profile_passphrase: passphrase)
      end

      # Add keychain to search list
      Keychain.search_list = [keychain_name] + Keychain.search_list

      yield

    ensure
      # Delete keychain when done5
      Keychain.delete(name: keychain_name)
    end
  end
end
