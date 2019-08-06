require_relative 'col'

desc "get data, convert to sql, upload to amazon s3"
task :all do
  begin
    Col.all()
  rescue Exception => e
    raise e
  end
end

desc "get and unzip data"
task :fetch do
  begin
    Col.fetch()
  rescue Exception => e
    raise e
  end
end

desc "create sql database"
task :sql do
  begin
    Col.sql()
  rescue Exception => e
    raise e
  end
end

desc "upload database to s3"
task :s3 do
  begin
    Col.s3()
  rescue Exception => e
    raise e
  end
end

desc "delete files not needed"
task :clean do
  begin
    Col.clean()
  rescue Exception => e
    raise e
  end
end
