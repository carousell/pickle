bootstrap:
	pod install --project-directory=Example && open Example/Pickle.xcworkspace

pod-install:
	pod install --project-directory=Example

build:
	set -o pipefail && xcodebuild -workspace Example/Pickle.xcworkspace -scheme Pickle clean build | bundle exec xcpretty -c

test:
	set -o pipefail && xcodebuild \
	-workspace Example/Pickle.xcworkspace \
	-scheme Pickle-Example \
	-destination 'platform=iOS Simulator,name=iPhone X,OS=12.0' \
	CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO \
	clean test | bundle exec xcpretty -c

bump:
ifeq (,$(strip $(version)))
	# Usage: make bump version=<number>
else
	ruby -pi -e "gsub(/'\d+\.\d+\.\d+'/i, \"'"$(version)"'\")" Pickle.podspec
	ruby -pi -e "gsub(/:\s\d+\.\d+\.\d+/i, \": "$(version)"\")" .jazzy.yml
	cd Example && xcrun agvtool new-marketing-version $(version)
	xcrun agvtool new-marketing-version $(version)
	bundle exec pod install --project-directory=Example
endif

carthage:
	set -o pipefail && carthage build --no-skip-current --verbose | bundle exec xcpretty -c

docs:
	test -d docs || git clone -b gh-pages --single-branch https://github.com/carousell/pickle.git docs
	cd docs && git fetch origin gh-pages && git clean -f -d
	cd docs && git checkout gh-pages && git reset --hard origin/gh-pages
	bundle exec jazzy --config .jazzy.yml

	for file in "html" "css" "js" "json"; do \
		echo "Cleaning whitespace in *."$$file ; \
		find docs/output -name "*."$$file -exec sed -E -i '' -e 's/[[:blank:]]*$///' {} \; ; \
	done

	cp -rfv docs/output/* docs
	cd docs && \
	git add . && \
	git diff-index --quiet HEAD || \
	git commit -m "[Docs] Update documentation at $(shell date -u +'%Y-%m-%d %H:%M:%S %z')"

update-docs:
	make -B docs
	cd docs && git push origin gh-pages
