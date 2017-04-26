carthage:
	set -o pipefail && carthage build --no-skip-current --verbose | bundle exec xcpretty -c

