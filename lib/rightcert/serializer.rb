module RightCert
  
  # Serializer implementation which secures messages by using
  # X.509 certificate sigining.
  class Serializer
    
    # Initialize serializer, must be called prior to using it.
    #
    #  * 'identity':   Identity associated with serialized messages
    #  * 'cert':       Certificate used to sign serialized messages and
    #                  decrypt encrypted messages
    #  * 'key':        Private key corresponding to 'cert'
    #  * 'store':      Certificate store. Exposes certificates used for
    #                  encryption and signature validation.
    #  * 'encrypt':    Whether data should be signed and encrypted ('true')
    #                  or just signed ('false'), 'true' by default.
    #
    def Serializer.init(identity, cert, key, store, encrypt = true)
      @identity = identity
      @cert = cert
      @key = key
      @store = store
      @encrypt = encrypt
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
      YAML.dump({ :id => @identity, :data => yaml, :signature => sig.to_s})
    end
    
    # Unserialize data using certificate store
    def Serializer.load(yaml)
      raise "Missing certificate store" unless @store
      data = YAML.load(yaml)
      sig = Signature.from_data(data[:signature])
      certs = @store.get_signer(data[:id])
      certs = [ certs ] unless certs.respond_to?(:each)
      yml = data[:data] if certs.any? { |c| sig.match?(c) }
      if yml && @encrypt
        key, cert = @store.get_encryption_key_and_cert(data[:id])
        yml = EncryptedDocument.from_data(yml).decrypted_data(key, cert)
      end
      YAML.load(yml) if yml
    end
       
  end
end
