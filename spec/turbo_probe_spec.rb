require 'spec_helper'

RSpec.describe 'turbo probe' do
  it 'prints turbo pins' do
    map = rails_workspace
    probes = {
      'Turbo::Native::Navigation' => %w[hotwire_native_app? recede_or_redirect_to recede_or_redirect_back_or_to
                                          refresh_or_redirect_to refresh_or_redirect_back_or_to resume_or_redirect_to
                                          resume_or_redirect_back_or_to],
      'ActionController::Base' => %w[hotwire_native_app? recede_or_redirect_to recede_or_redirect_back_or_to
                                     refresh_or_redirect_to refresh_or_redirect_back_or_to resume_or_redirect_to
                                     resume_or_redirect_back_or_to],
      'Turbo::Broadcastable' => %w[broadcast_append broadcast_render_to broadcast_action_later_to],
      'ActiveRecord::Base' => %w[broadcast_append broadcast_render_to broadcast_action_later_to]
    }
    class_probes = {
      'Turbo::Broadcastable::ClassMethods' => %w[broadcasts_to broadcasts_refreshes suppressing_turbo_broadcasts broadcast_target_default],
    }
    ar_class = %w[broadcasts_to broadcasts_refreshes suppressing_turbo_broadcasts broadcast_target_default]
    report = lambda do |klass, scope, name, pins|
      if pins.empty?
        puts "PROBE #{Solargraph::VERSION} #{ENV['MATRIX_RAILS_VERSION']} #{klass}#{scope == :class ? '.' : '#'}#{name} MISSING"
      else
        pins.each do |p|
          src = p.respond_to?(:source) ? p.source.inspect : '?'
          file = p.location&.filename.to_s.sub(%r{.*/gems/}, '')
          tags = member_tags(p.typify(map)).sort.uniq rescue ['ERR']
          params = p.respond_to?(:parameters) ? p.parameters.map { |pa| "#{pa.decl}:#{pa.name}" }.join(',') : ''
          puts "PROBE #{Solargraph::VERSION} #{ENV['MATRIX_RAILS_VERSION']} #{klass}#{scope == :class ? '.' : '#'}#{name} FOUND path=#{p.path} src=#{src} file=#{file} types=#{tags} params=#{params}"
        end
      end
    end
    probes.each do |klass, names|
      meths = map.get_methods(klass, scope: :instance, visibility: %i[public protected private])
      names.each { |n| report.call(klass, :instance, n, meths.select { |p| p.name == n }) }
    end
    class_probes.each do |klass, names|
      meths = map.get_methods(klass, scope: :instance, visibility: %i[public protected private])
      names.each { |n| report.call(klass, :instance, n, meths.select { |p| p.name == n }) }
    end
    meths = map.get_methods('ActiveRecord::Base', scope: :class, visibility: %i[public protected private])
    ar_class.each { |n| report.call('ActiveRecord::Base', :class, n, meths.select { |p| p.name == n }) }
  end
end
