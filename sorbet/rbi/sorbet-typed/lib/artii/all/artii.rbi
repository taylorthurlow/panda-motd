# typed: strong

module Artii
  class Base
    sig { params(params: T.any(String, T::Hash[Symbol, T.untyped])).void }

    def initialize(params = {}); end
  end
end
