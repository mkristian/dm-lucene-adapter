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
end
