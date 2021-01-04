require 'aws-sdk'
require 'faraday'
require 'sqlite3'
require 'date'
require 'zip'
require 'oga'

Aws.config.update({
  region: 'us-west-2',
  credentials: Aws::Credentials.new(ENV['AWS_S3_WRITE_ACCESS_KEY'], ENV['AWS_S3_WRITE_SECRET_KEY'])
})
$s3 = Aws::S3::Client.new

def latest_version_url
	dca_page = 'https://download.catalogueoflife.org/col/monthly/'
	res = Faraday.get dca_page;
	html = Oga.parse_html(res.body);
	last_download = html.xpath('//tr//a').last.attr("href").text
	url = dca_page + last_download
	return url
end

$col_url = latest_version_url
$col_file = $col_url.split("/").last

module Col

	def self.fetch
		puts 'fetching/unzipping data from COL servers'
		fetch_col($col_file)
		unzip_col($col_file)
	end

	def self.sql
		puts 'creating SQLite database, and loading COL taxonomy'
		system('sh do_col.sh')
	end

	def self.zip
		puts 'zipping sqlite db file into a zip file'
		zip_up()
	end

	def self.s3
		puts 'uploading SQLite database to Amazon S3'
		to_s3()
	end

	def self.all
		if is_new?($col_file)
			puts 'new data, updating'
			fetch_col($col_file)
			unzip_col($col_file)
			system('sh do_col.sh')
			zip_up()
			to_s3()
			clean_up($col_file)
		else
			puts 'data is old, not updating'
		end
	end

	def self.clean
		clean_up()
	end

end

def is_new?(file)
	# initialize Faraday connection object
	conn = Faraday.new do |x|
	  x.adapter Faraday.default_adapter
	end

	# check last-modified header
	res = conn.head $col_url;
	lm = DateTime.parse(res.headers['last-modified']).to_time

	# file last modified
	begin
		fm = File.stat(file).mtime
	rescue Exception => e
		fm = nil
	end

	if fm.nil?
		return true
	end

	# return boolean
	return lm > fm
end

def fetch_col(file)
	if !File.exist?(file)
		# initialize Faraday connection object
		conn = Faraday.new do |x|
		  x.adapter Faraday.default_adapter
		end

		# get zip file
		res = conn.get $col_url;

		# write zip file to disk
		File.open(file, 'wb') { |fp| fp.write(res.body) }
	else
		puts "'%s' found, skipping download" % file
	end
end

def unzip_col(file)
	Zip::File.open(file) do |zip_file|
	  zip_file.glob("*.tsv") do |f|
			begin
				zip_file.extract(f, f.name) unless File.exist?(f.name)
			end
	  end
	end
end

def zip_up
	Zip::File.open('col.zip', Zip::File::CREATE) do |zip|
	  zip.add("col.sqlite", "col.sqlite")
	end
end

def to_s3
	File.open("col.zip", 'rb') do |f|
  		$s3.put_object(acl: "public-read", storage_class: "STANDARD_IA", bucket: 'taxize-dbs', key: 'col.zip', body: f)
	end
end

def clean_up(file)
	files_to_clean = ["Taxon.tsv", "VernacularName.tsv", "SpeciesProfile.tsv",
		"Distribution.tsv", "gbif.sqlite", "col.sqlite", "col.zip", file]
	files_to_clean.each { |x| File.unlink(x) unless !File.exists?(x) }
end
