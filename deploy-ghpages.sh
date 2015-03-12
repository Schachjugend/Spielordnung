#!/bin/bash
echo "Richte git ein"

CURRENT_COMMIT=`git rev-parse HEAD`

cp Spielordnung.md ../Spielordnung.md
git checkout gh-pages > /dev/null
cd ..

echo "Lade md-tools"
git clone -b master https://github.com/Schachjugend/md-tools.git md-tools > /dev/null 2>&1 || exit 1

rm -r Spielordnung/Spielordnung*

echo "Erstelle Exporte"
./md-tools/bin/schachjugend-md spielordnung all ./Spielordnung.md ./Spielordnung || exit 1

cd Spielordnung/

echo "Push auf gh-pages"
git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"

git add -A
git commit --allow-empty -m "Aktuelle Fassung per $CURRENT_COMMIT" || exit 1
git push origin gh-pages > /dev/null 2>&1 || exit 1

echo "Exporte erfolgreich erstellt."
exit 0
