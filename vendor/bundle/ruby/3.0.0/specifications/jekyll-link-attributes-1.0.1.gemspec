# -*- encoding: utf-8 -*-
# stub: jekyll-link-attributes 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-link-attributes".freeze
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.org" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["twinsunllc".freeze]
  s.bindir = "exe".freeze
  s.date = "2022-09-14"
  s.description = "This plugin adds `rel` and `target` attributes to all external links in your Jekyll site.".freeze
  s.email = ["contact@twinsunsolutions.com".freeze]
  s.homepage = "https://github.com/twinsunllc/jekyll-link-attributes".freeze
  s.licenses = ["BSD 3-Clause".freeze]
  s.rubygems_version = "3.3.5".freeze
  s.summary = "This plugin adds `rel` and `target` attributes to all external links in your Jekyll site.".freeze

  s.installed_by_version = "3.3.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, [">= 2.0.0"])
    s.add_development_dependency(%q<jekyll>.freeze, [">= 4.0.0"])
    s.add_development_dependency(%q<nokogiri>.freeze, [">= 1.0.0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 10.0.0"])
  else
    s.add_dependency(%q<bundler>.freeze, [">= 2.0.0"])
    s.add_dependency(%q<jekyll>.freeze, [">= 4.0.0"])
    s.add_dependency(%q<nokogiri>.freeze, [">= 1.0.0"])
    s.add_dependency(%q<rake>.freeze, [">= 10.0.0"])
  end
end
