module RightCert
  
  # Serializer implementation which secures messages by using
  # X.509 certificate sigining.
  class Serializer
    
    # Initialize serializer, must be called prior to using it.
    #
    #  - 'identity':   Identity associated with serialized messages
    #  - 'cert':       Certificate used to sign and decrypt serialized messages
    #  - 'key':        Private key corresponding to 'cert'
    #  - 'store':      Certificate store. Exposes certificates used for
    #                  encryption and signature validation.
    #  - 'encrypt':    Whether data should be signed and encrypted ('true')
    #                  or just signed ('false'), 'true' by default.
    #
    def Serializer.init(identity, cert, key, store, encrypt = true)
      @identity = identity
      @cert = cert
      @key = key
      @store = store
      @encrypt = encrypt
    end
    
    # Was serializer initialized?
    def Serializer.initialized?
      @identity && @cert && @key && @store
    end

    # Serialize message and sign it using X.509 certificate
    def Serializer.dump(obj)
      raise "Missing certificate identity" unless @identity
      raise "Missing certificate" unless @cert
      raise "Missing certificate key" unless @key
      raise "Missing certificate store" unless @store || !@encrypt
      yaml = YAML.dump(obj)
      if @encrypt
        certs = @store.get_recipients(obj)
        yaml = EncryptedDocument.new(yaml, certs).encrypted_data
      end
      sig = Signature.new(yaml, @cert, @key)
      YAML.dump({ :id => @identity, :data => yaml, :signature => sig.data})
    end
    
    # Unserialize data using certificate store
    def Serializer.load(yaml)
      raise "Missing certificate store" unless @store
      raise "Missing certificate" unless @cert || !@encrypt
      raise "Missing certificate key" unless @key || !@encrypt
      data = YAML.load(yaml)
      sig = Signature.from_data(data[:signature])
      certs = @store.get_signer(data[:id])
      certs = [ certs ] unless certs.respond_to?(:each)
      yml = data[:data] if certs.any? { |c| sig.match?(c) }
      if yml && @encrypt
        yml = EncryptedDocument.from_data(yml).decrypted_data(@key, @cert)
      end
      YAML.load(yml) if yml
    end
       
  end
end
