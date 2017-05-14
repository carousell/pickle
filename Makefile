carthage:
	set -o pipefail && carthage build --no-skip-current --verbose | bundle exec xcpretty -c

docs:
	rm -rfv docs
	git clone -b gh-pages --single-branch https://github.com/carousell/pickle.git docs
	bundle exec jazzy --config .jazzy.yml
