#!/bin/bash
echo "Richte git ein"

CURRENT_COMMIT=`git rev-parse HEAD`

git clone -b gh-pages "https://${GH_TOKEN}@github.com/Schachjugend/Spielordnung.git" exporte > /dev/null 2>&1 || exit 1

echo "Lade md-tools"
git clone -b master https://github.com/Schachjugend/md-tools.git md-tools
cd md-tools
npm install
cd ..

rm -r exporte/Spielordnung*

echo "Erstelle Exporte"
./md-tools/bin/schachjugend-md spielordnung all ./Spielordnung.md ./exporte || exit 1

cd exporte/

echo "Push auf gh-pages"
git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"

git add -A
git commit --allow-empty -m "Aktuelle Fassung per $CURRENT_COMMIT" || exit 1
git push origin gh-pages > /dev/null 2>&1 || exit 1

echo "Exporte erfolgreich erstellt."
exit 0
