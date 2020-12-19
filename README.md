# Triplet

A simple Ruby DSL for defining templates. (Maybe) useful for defining single file [view
components](https://github.com/github/view_component).

Features:

* Easy to use "AST" for defining HTML tags. `[:a, { href: "/" }, "Home"]`
* DSL methods to make defining triplets easier. `a(href: "/") { "Home" }`
* Supports Rails helper methods. e.g. `form_for`, `text_field_tag`, `link_to`,
  etc.
* View Component support via `include Triplet::ViewComponent`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'triplet'
```

And then execute: `bundle install` in your shell.

## Usage

```ruby
nav_items = { "home": "/", "Sign Up": "/sign-up" }

Triplet.template {[
  nav(class: "max-w-3xl mx-auto flex") {[
    h1(class: "font-3xl") { "My App" },
    ul(class: "") {[
      nav_items.map do |name, link|
        li(class: "bold font-xl") {[ a(href: link.html_safe) { name } ]}
      end
    ]}
  ]},
  "Hello",
  span(class: "bold") { "world" },
]}
```

Will output the equivalent HTML:

```html
<nav class="max-w-3xl mx-auto flex">
   <h1 class="font-3xl">My App</h1>
   <ul class="">
      <li class="bold font-xl"><a href="/">home</a></li>
      <li class="bold font-xl"><a href="/sign-up">Sign Up</a></li>
   </ul>
</nav>
Hello<span class="bold">world</span>
```

The tag methods (e.g. `nav`, `h1`, `p`) are helpers that turn Ruby code into
triples, or 3 element arrays.

e.g. `p(class: "font-xl") { "hello world!" }` becomes `[:p, { class: "font-xl" }, "hello world!"]`

The two formats can be used interchangeably in templates.

If you need a custom tag, you can return a triplet directly:

```ruby
[:"my-tag", { "custom-attribute" => "value" }, ["body content"]]
# <my-tag custom-attribute="value">body content</my-tag>
```

### View Component Support

To use in view components, include the `Triplet::ViewComponent` module and
define a `call` method. The module will handle the rest.

```ruby
class NavComponent < ViewComponent::Base
  include Triplet::ViewComponent

  def template
    [
      h1 { "hello world" },
      render NavItemComponent.new(title: "Home", path: "/"),
      render NavItemComponent.new(title: "Pricing", path: "/pricing")
    ]
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BlakeWilliams/triplet.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
