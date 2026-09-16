# ComplexType#items is absent before Solargraph 0.51.2, and #map, the older
# spelling of the same iteration, is removed by
# https://github.com/castwide/solargraph/pull/1231 - the CI matrix spans both.
module TypeTags
  module_function

  # @param type [Solargraph::ComplexType]
  # @return [Array<String>]
  def of(type)
    type.respond_to?(:items) ? type.items.map(&:tag) : type.map(&:tag)
  end
end
