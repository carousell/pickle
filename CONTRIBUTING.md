## Feedback

We'd love the feedback from you. Please create [GitHub Issues](https://github.com/carousell/pickle/issues) for feature discussions, bug reports and anything you'd like us to know. Be sure to check out the [closed issues](https://github.com/carousell/pickle/issues?q=is:closed) before you open new ones.

## Contributing

1. Fork the repo.

2. Create a local feature branch from the latest `master`, prefix it with **feature/** and use **hyphen-separated-words** to name your branch:

  ```sh
  git checkout -b feature/your-branch
  ```

3. Add your changes and push it to your fork

4. Create a pull request

## Dependencies

CocoaPods is used to set up the example project. Follow the [instruction](https://guides.cocoapods.org/using/getting-started.html#installation) to install it before you set up the project by running `make bootstrap`.

**Pickle** uses Ruby 2.3.4 and [Bundler](http://bundler.io/) to manage dependencies on Travis CI. It's not required locally. However if you have Ruby environment set up, additional tools are specified in the [Gemfile](https://github.com/carousell/pickle/blob/master/Gemfile).
