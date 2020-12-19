# Triplet

A simple Ruby DSL for defining templates. (Maybe) useful for defining single file [view
components](https://github.com/github/view_component).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'triplet'
```

And then execute: `bundle install` in your shell.

## Usage

```ruby
nav_items = { "home": "/", "Sign Up": "/sign-up" }
template = Template.new # Create a new template

template.eval do
  nav class: "max-w-3xl mx-auto flex" do
    h1(class: "font-3xl") { "My App" }

    ul class: "" do
      nav_items.each do |name, link|
        li class: "bold font-xl" do
          a href: link.html_safe { name }
        end
      end
    end
  end

  text "Hello"
  span(class: "bold") { "world" }
end
```

Will output the equivalent HTML:

```html
<nav class="max-w-3xl mx-auto flex">
   <h1 class="font-3xl">My App</h1>
   <ul class="">
      <li class="bold font-xl"><a href="/"></a></li>
      <li class="bold font-xl"><a href="/sign-up"></a></li>
   </ul>
</nav>
Hello<span class="bold">world</span>
```

If you need a custom tag, you can use the `tag` helper method:

```ruby
tag("my-tag", "custom-attribute" => "value") { "body content" }
# <my-tag custom-attribute="value">body content</my-tag>
```

To output strings with no wrapping tag, use the `text` helper:

```ruby
text "hello "
b { "world" }
# hello <b>world</b>
```

### View Component Support

To use in view components, include the `Triplet::ViewComponent` module and
define a `template` method. The module will handle the rest.

```ruby
class NavComponent < ::ViewComponent::Base
  include Triplet::ViewComponent

  def template
    h1 { "hello world" }

    render NavItemComponent.new(title: "Home", path: "/")
    render NavItemComponent.new(title: "Pricing", path: "/pricing")
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
