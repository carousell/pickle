#!/bin/sh

cd docs && pwd

if [[ "${TRAVIS_COMMIT_MESSAGE}" = Merge* ]] && [[ -n "${GH_PAGES_GITHUB_API_TOKEN}" ]]; then
  echo "Updating gh-pages"
  git remote add upstream "https://${GH_PAGES_GITHUB_API_TOKEN}@github.com/carousell/pickle.git"
  git push --quiet upstream HEAD:gh-pages
  git remote remove upstream
else
  echo "Skip gh-pages updates for the commit:"
  echo "\n    ${TRAVIS_COMMIT_MESSAGE}\n"
fi

cd -
