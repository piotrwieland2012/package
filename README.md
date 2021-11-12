echo "# package" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/piotrwieland2012/package.git
git push -u origin main
