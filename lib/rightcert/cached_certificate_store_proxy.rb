module RightCert

  # Proxy to actual certificate store which caches results in an LRU
  # cache.
  class CachedCertificateStoreProxy
    
    # Initialize cache proxy with given certificate store.
    def initialize(store)
      @signer_cache = CertificateCache.new
      @encrypter_cache = CertificateCache.new
      @store = store
    end
    
    # Results from 'get_recipients' are not cached
    def get_recipients(obj)
      @store.get_recipients(obj)
    end

    # Check cache for signer certificate
    def get_signer(id)
      @signer_cache.get(id) { @store.get_signer(id) }
    end

    # Check cache for encrypting certificate and key
    def get_encryption_key_and_cert(id)
      @encrypter_cache.get(id) { @store.get_encryption_key_and_cert(id) }
    end

  end  
end
