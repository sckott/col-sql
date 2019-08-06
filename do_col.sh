echo "removing any quotes in data files"
# sed -i '' 's/\"//g' taxa.txt # mac version
# sed -i '' 's/\"//g' reference.txt # mac version
# sed -i '' 's/\"//g' vernacular.txt # mac version
# sed -i '' 's/\"//g' speciesprofile.txt # mac version
# sed -i '' 's/\"//g' distribution.txt # mac version
# sed -i '' 's/\"//g' description.txt # mac version
sed -i 's/\"//g' taxa.txt # linux version
sed -i 's/\"//g' reference.txt # linux version
sed -i 's/\"//g' vernacular.txt # linux version
sed -i 's/\"//g' speciesprofile.txt # linux version
sed -i 's/\"//g' distribution.txt # linux version
sed -i 's/\"//g' description.txt # linux version
echo "quotes removed"
echo "loading schema"
sqlite3 col.sqlite < schema.sql
echo "loading data files into database"
echo '.mode tabs\n.separator "\\t"\n.header off\n.import distribution.txt distribution' | sqlite3 col.sqlite
echo '.mode tabs\n.separator "\\t"\n.header off\n.import description.txt description' | sqlite3 col.sqlite
echo '.mode tabs\n.separator "\\t"\n.header off\n.import speciesprofile.txt speciesprofile' | sqlite3 col.sqlite
echo '.mode tabs\n.separator "\\t"\n.header off\n.import reference.txt reference' | sqlite3 col.sqlite
echo '.mode tabs\n.separator "\\t"\n.header off\n.import vernacular.txt vernacular' | sqlite3 col.sqlite
echo '.mode tabs\n.separator "\\t"\n.header off\n.import taxa.txt taxa' | sqlite3 col.sqlite
echo 'creating index'
echo "CREATE UNIQUE INDEX id on taxa (taxonID);" | sqlite3 col.sqlite
echo "\nall done!"
