module RightCert

  # Simple certificate store, serves a static set of certificates.
  class StaticCertificateStore
    
    # Initialize store
    def initialize(recipients_certs, signer_certs, encryption_cert, encryption_key)
      signer_certs = [ signer_certs ] unless signer_certs.respond_to?(:each)
      @signer_certs = signer_certs 
      recipients_certs = [ recipients_certs ] unless recipients_certs.respond_to?(:each)
      @recipients_certs = recipients_certs
      @encryption_cert = encryption_cert
      @encryption_key = encryption_key
    end
    
    # Retrieve signer certificate for given id
    def get_signer(identity)
      @signer_certs
    end

    # Recipient certificate(s) that will be able to decrypt the serialized data
    def get_recipients(obj)
      @recipients_certs
    end
    
    # Retrieve private key and certificate required for decryption
    def get_encryption_key_and_cert(identity)
      [ @encryption_key, @encryption_cert ]
    end
  end  
end
