require File.dirname(__FILE__) +  '/spec_helper'

describe DataMapper::Adapters::LuceneAdapter do

  it "should create" do
    Book.create(:author => "kristian", :title => "me and the corner").new?.should be_false
  end

  it "should read all" do
    size = Book.all.size
    (1..3).each do
      Book.create(:author => "kristian", :title => "me and the corner")
    end
    b = Book.all 
    b.size.should == size + 3
  end

  it "should delete" do
    books = []
    (1..4).each do
      books << Book.create(:author => "kristian", :title => "me and the corner")
    end
    id = books.last.id
    size = Book.all.size
    books.each do |b| 
      b.destroy if b.id % 2 == 0
    end
    b = Book.all 
    size.should == b.size + 2
    book = Book.create(:author => "kristian", :title => "me and the corner")
    id.should < book.id
  end

  it 'should read a single' do
    book = Book.create(:author => "kristian", :title => "me and the corner")
    b = Book.get(book.id)
    b.id.should == book.id
  end

  it 'should update' do
    book = Book.create(:author => "kristian", :title => "me and the corner")
    book.author = "sanuka"
    book.save
    b = Book.get(book.id)
    b.author.should == "sanuka"
  end

  describe "search" do

    before :all do
      @size = Book.all(:author => "sanuka").size
      @len = 5
      (1..@len).each do |i|
        Book.create(:author => "kristian", :title => "me and the corner #{i}")
        Book.create(:author => "sanuka", :title => "me and the corner #{i}")
        Book.create(:author => "#{i}sanuka", :title => "me and the corner")
        Book.create(:author => "#{i}sanuka#{i}", :title => "me and the corner")
      end
    end

    describe "ascending" do

      after :each do        
        id = 0
        @books.each do |b|
          b.id.should > id
          id = b.id
        end
      end

      it 'should find 5 with simple query' do      
        @books = Book.all(:author => "sanuka")
        @books.size.should == @size + @len
        @books.each { |b| b.author.should == "sanuka" }
      end
      
      it 'should find 5 with not query' do      
        @books = Book.all(:author.not => "sanuka")
        @books.each { |b| b.author.should_not == "sanuka" }
        (@books.size + @size + @len).should == Book.all.size
      end
      
      it 'should find nothing with simple query' do
        @books = Book.all(:author => "saumya")
        @books.size.should == 0
      end

      it 'should find 5 with fuzzy query' do
        @books = Book.all(:author.like => "sanaku")
        @books.size.should == @size + @len
        @books.each { |b| b.author.should =~ /sanuka/ }
      end

      it 'should find 5 with fuzzy query on total' do
        @books = Book.all(:total.like => "sanaku corner")
        @books.size.should == @size + @len
        @books.each { |b| b.author.should =~ /sanuka/ }
      end

      it 'should find 5 with single char wildcards query' do
        @books = Book.all(:author.like => "san?k?")
        @books.size.should == @size + @len
        @books.each { |b| b.author.should =~ /sanuka/ }
      end

      it 'should find 5 with wildcards query' do
        @books = Book.all(:author.like => "sa*ka")
        @books.size.should == @size + @len
        @books.each { |b| b.author.should =~ /sanuka/ }
      end

      it 'should obey offset' do
        @books = Book.all(:author.like => "san?k?", :limit => @size)
        @books.size.should == @size
      end

      it 'should obey offset with empty query' do
        @books = Book.all(:limit => @size)
        @books.size.should == @size
      end

      it 'should obey offset and limit' do
        @books = Book.all(:author.like => "san?k?", :offset => @size, :limit => @len)
        @books.size.should == @len
      end

      it 'should obey offset and limit with empty query' do
        @books = Book.all(:offset => @size, :limit => @len)
        @books.size.should == @len
      end
    end
    
    describe "descending" do

      after :each do        
        id = 12311230123321
        @books.each do |b|
          b.id.should < id
          id = b.id
        end
      end

      it 'should obey offset and limit descending order' do
        @books = Book.all(:author.like => "san?k?", :offset => @size, :limit => @len, :order => [:id.desc])
        @books.size.should == @len
      end
      
      it 'should obey offset and limit descending order with emtpy query' do
        @books = Book.all(:offset => @len, :limit => @size, :order => [:id.desc])
        @books.size.should == @size
      end
    end
  end
end
