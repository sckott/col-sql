echo "removing any quotes in data files"
# sed -i '' 's/\"//g' Taxon.csv # mac version
# sed -i '' 's/\"//g' VernacularName.csv # mac version
# sed -i '' 's/\"//g' SpeciesProfile.csv # mac version
# sed -i '' 's/\"//g' Distribution.csv # mac version
sed -i 's/\"//g' Taxon.csv # linux version
sed -i 's/\"//g' VernacularName.csv # linux version
sed -i 's/\"//g' SpeciesProfile.csv # linux version
sed -i 's/\"//g' Distribution.csv # linux version
echo "quotes removed"
echo "loading schema"
# sqlite3 col.sqlite < schema2.sql
echo "loading data files into database"
echo '.mode tabs\n.separator "\\t"\n.header off\n.import Distribution.csv distribution' | sqlite3 col.sqlite
echo '.mode tabs\n.separator "\\t"\n.header off\n.import SpeciesProfile.csv speciesprofile' | sqlite3 col.sqlite
echo '.mode tabs\n.separator "\\t"\n.header off\n.import VernacularName.csv vernacular' | sqlite3 col.sqlite
echo '.mode tabs\n.separator "\\t"\n.header off\n.import Taxon.csv taxa' | sqlite3 col.sqlite
echo 'creating indices'
echo "CREATE UNIQUE INDEX id on taxa (taxonID);" | sqlite3 col.sqlite
echo "CREATE INDEX sciname on taxa (scientificName);" | sqlite3 col.sqlite
echo "CREATE INDEX parname on taxa (parentNameUsageID);" | sqlite3 col.sqlite
echo "\nall done!"
