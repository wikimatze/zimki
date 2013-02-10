require "zimki"

describe  Zimki do
  before :all do
    current_dir    = File.dirname(__FILE__)
    @italique      = "//italique//"
    @bold          = "**bold**"
    @highlight     = "__highlight__"
    @link          = "* Look on [[http://wikimatze.de|wikimatze]] best page in the world"
    @link_normal   = "* Look on http://wikimatze.de best page in the world"
    @bullet_first  = "\t* texttt  ss //\_ ! ? = \foo a aa"
    @bullet_second = "\t\t* texttt  ss //\_ ! ? = \foo a aa"
    @bullet_third  = "\t\t\t* texttt  ss //\_ ! ? = \foo a aa"
    @verbatim      = "'''\na!aa\n'b?b_b\n\ta\"a\n''''"
    @content_type = "Content-Type: text/x-zim-wiki"
    @wiki_format = "Wiki-Format: zim 0.4"
    @creation_format = "Creation-Date: 2010-07-15T15:44:43.025424"
    @big_header = "====== notes!?  1 - ======"
    @created = "Created Thursday 15 July 2010\n"
    @h_one = "==== The 10-day MBA ====\n"
    @h_two = "=== This is h2 ===\n"
    @h_three = "== This is h3 ==\n"
    @image = "{{~/Dropbox/pics/Screenshot.png}}"
    @zimki = Zimki.new
    @file = File.join(current_dir, 'source', 'src.txt')
    @file_back = File.join(current_dir, 'source', 'dst.txt')
    @file_expectation = File.join(current_dir, 'source', 'expectation.textile')
    @file_compare_one = File.join(current_dir, 'source', 'a.txt')
    @file_compare_two = File.join(current_dir, 'source', 'b.txt')
    @leading_newlines = "\n\n\n"
  end

  it "should convert italique for textile" do
    @zimki.convert_italique_to_textile(@italique).should == "_italique_"
  end

  it "should convert bold for textile" do
    @zimki.convert_bold_to_textile(@bold).should == "*bold*"
  end

  it "should convert highlighted text to inline code" do
    @zimki.convert_highlight_to_textile(@highlight).should == "@highlight@"
  end

  it "should convert a link href link" do
    @zimki.convert_link_to_textile(@link).should == "* Look on \"wikimatze\":http://wikimatze.de best page in the world"
  end

  it "should convert normal link without alt tag" do
    @zimki.convert_link_to_textile(@link_normal).should == "* Look on \"http://wikimatze.de\":http://wikimatze.de best page in the world"
  end

  it "should convert first bullets" do
    @zimki.convert_first_bullet(@bullet_first).should == "** texttt  ss //_ ! ? = \foo a aa"
  end

  it "should convert second bullets" do
    @zimki.convert_second_bullet(@bullet_second).should == "*** texttt  ss //_ ! ? = \foo a aa"
  end

  it "should convert third bullets" do
    @zimki.convert_third_bullet(@bullet_third).should == "**** texttt  ss //_ ! ? = \foo a aa"
  end

  it "should convert verbatim" do
    @zimki.convert_verbatim_to_textile(@verbatim).should == "{% highlight plain %}\na!aa\n'b?b_b\n\ta\"a\n{% endhighlight %}"
  end

  it "should remove content type" do
    @zimki.remove_content_type_textile(@content_type).should == ""
  end

  it "should remove wiki format" do
    @zimki.remove_wiki_format(@wiki_format).should == ""
  end

  it "should remove creation date" do
    @zimki.remove_creation_date(@creation_format).should == ""
  end

  it "should remove the header " do
    @zimki.remove_big_header(@big_header).should == ""
  end

  it "should remove created" do
    @zimki.remove_created(@created).should == ""
  end

  it "should create h1 title" do
    @zimki.h_one_title(@h_one).should == "h1. The 10-day MBA \n\n\n"
  end

  it "should create h2 title" do
    @zimki.h_two_title(@h_two).should == "h2. This is h2 \n"
  end

  it "should create h3 title" do
    @zimki.h_three_title(@h_three).should == "h3. This is h3 \n"
  end

  it "should convert images" do
    @zimki.convert_image(@image).should == "!http://~/Dropbox/pics/Screenshot.png!"
  end

  it "should load a config test file" do
    @zimki.load_test_file(@file).should == true
  end

  it "should replace leading newlines" do
    @zimki.replace_leading_newlines(@leading_newlines).should == ""
  end

  it "should backup test file" do
    @zimki.copy_test_file(@file, @file_back).should == true
  end

  it "should compare the expected conversion with actual conversion" do
    @zimki.compare_files(@file_compare_one, @file_compare_two).should == true
  end

  it "should converte test file and compare it with expected output" do
    @zimki.copy_test_file(@file, @file_back)
    text = @zimki.textile_conversion(@file_back)
    File.open(@file_back, 'w') do |file|
      file.puts text
    end

    @zimki.compare_files(@file_back, @file_expectation).should == true
  end
end
