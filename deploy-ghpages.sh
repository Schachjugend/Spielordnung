#!/bin/bash
if [ "${TRAVIS_PULL_REQUEST}" = "true" ]; then
  echo "Nur bei Push zum Masterbranch"
  exit 0
fi

echo "Richte git ein"

CURRENT_COMMIT_JSPO=`git rev-parse HEAD`

git clone -b gh-pages "https://${GH_TOKEN}@github.com/Schachjugend/Spielordnung.git" exporte > /dev/null 2>&1 || exit 1

echo "Lade md-tools"
git clone -b master https://github.com/Schachjugend/md-tools.git md-tools
cd md-tools
npm install
CURRENT_COMMIT_MD_TOOLS=`git rev-parse HEAD`
cd ..

rm -rf exporte/Spielordnung*

echo "Erstelle Exporte"
./md-tools/bin/schachjugend-md spielordnung all --commit-md=$CURRENT_COMMIT_JSPO --commit-creator=$CURRENT_COMMIT_MD_TOOLS ./Spielordnung.md ./exporte || exit 1

cd exporte/

echo "Push auf gh-pages"
git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"

git add -A
git commit --allow-empty -m "Aktuelle Fassung per $CURRENT_COMMIT_JSPO" || exit 1
git push origin gh-pages > /dev/null 2>&1 || exit 1

echo "Exporte erfolgreich erstellt."
exit 0
