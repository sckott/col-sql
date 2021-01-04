echo "removing any quotes in data files"
sed -i '' 's/\"//g' Taxon.tsv # mac version
sed -i '' 's/\"//g' VernacularName.tsv # mac version
sed -i '' 's/\"//g' SpeciesProfile.tsv # mac version
sed -i '' 's/\"//g' Distribution.tsv # mac version
# sed -i 's/\"//g' Taxon.tsv # linux version
# sed -i 's/\"//g' VernacularName.tsv # linux version
# sed -i 's/\"//g' SpeciesProfile.tsv # linux version
# sed -i 's/\"//g' Distribution.tsv # linux version
echo "quotes removed"
echo "loading schema"
sqlite3 col.sqlite < schema2.sql
echo "loading data files into database"
echo '.mode tabs\n.separator "\\t"\n.header off\n.import Distribution.tsv distribution' | sqlite3 col.sqlite
echo '.mode tabs\n.separator "\\t"\n.header off\n.import SpeciesProfile.tsv speciesprofile' | sqlite3 col.sqlite
echo '.mode tabs\n.separator "\\t"\n.header off\n.import VernacularName.tsv vernacular' | sqlite3 col.sqlite
echo '.mode tabs\n.separator "\\t"\n.header off\n.import Taxon.tsv taxa' | sqlite3 col.sqlite
echo 'creating indices'
echo "CREATE UNIQUE INDEX id on taxa (taxonID);" | sqlite3 col.sqlite
echo "CREATE INDEX sciname on taxa (scientificName);" | sqlite3 col.sqlite
echo "CREATE INDEX parname on taxa (parentNameUsageID);" | sqlite3 col.sqlite
echo "\nall done!"
