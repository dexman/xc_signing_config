require 'open3'
require 'tempfile'

module XCSigningConfig
  class Keychain
    attr_reader :name

    def initialize(name:, password:)
      @name = name
      @password = password
    end

    def unlock
      security('unlock-keychain', '-p', password, name)
    end

    def import_data(data:, format:, passphrase:, allowed_applications:)
      Tempfile.create('data') do |file|
        file.write(data)
        file.close

        import_file(
          file: file.path,
          format: format,
          passphrase: passphrase,
          allowed_applications: allowed_applications)
      end
    end

    def import_file(file:, format:, passphrase:, allowed_applications:)
      cmd = ['import', file, '-f', format, '-k', name, '-P', passphrase]
      allowed_applications.each do |app|
        cmd.concat(['-T', app])
      end
      security(*cmd)
    end

    def set_timeout(seconds:)
      cmd = ['set-keychain-settings']
      cmd += ['-t', seconds.to_s] if seconds > 0
      security(*cmd)
    end

    class << self
      def search_list
        _, output = security('list-keychain')
        output.strip.split(/\s+/).map {|item| strip_quotes(item)}
      end

      def search_list=(lst)
        cmd = ['list-keychain', '-s'] + lst
        security(*cmd)
      end

      def create(name:, password:)
        success, _ = security('create-keychain', '-p', password, name)
        success ? Keychain.new(name: name, password: password) : nil
      end

      def delete(name:)
        security('delete-keychain', name)
      end
    end

    private

    attr_reader :password

    def security(*args)
      self.class.security(*args)
    end

    class << self
      def security(*args)
        cmd = ['security'] + args
        output, status = Open3.capture2e(*cmd)
        [status.success?, output]
      end

      def strip_quotes(str)
        str.sub(/"(?<str>.*)"/, '\k<str>')
      end
    end
  end
end
