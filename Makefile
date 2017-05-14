bump:
ifeq (,$(strip $(version)))
	# Usage: make bump version=<number>
else
	ruby -pi -e "gsub(/'\d+\.\d+\.\d+'/i, \"'"$(version)"'\")" Pickle.podspec
	ruby -pi -e "gsub(/:\s\d+\.\d+\.\d+/i, \": "$(version)"\")" .jazzy.yml
	cd Example && xcrun agvtool new-marketing-version $(version)
	xcrun agvtool new-marketing-version $(version)
endif

carthage:
	set -o pipefail && carthage build --no-skip-current --verbose | bundle exec xcpretty -c

docs:
	rm -rfv docs
	git clone -b gh-pages --single-branch https://github.com/carousell/pickle.git docs
	bundle exec jazzy --config .jazzy.yml
