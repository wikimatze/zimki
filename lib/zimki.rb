require 'fileutils'

class Zimki

  def remove_content_type_textile(text)
    show_regexp(text, /Content-Type:([A-Za-z0-9\/:<>!?_\s-]*)/, "content_type")
  end

  def remove_wiki_format(text)
    show_regexp(text, /Wiki-Format:[A-Za-z0-9.\s]*/, "wiki_format")
  end

  def remove_creation_date(text)
    show_regexp(text, /Creation-Date:([A-Za-z0-9.:!?_\s-]*)/, "creation_date")
  end

  def remove_big_header(text)
    show_regexp(text, /======([A-Za-z0-9.:!?_\s-]*)======/, "big_header")
  end

  def remove_created(text)
    show_regexp(text, /Created([A-Za-z0-9.:!?_\s-]*)\n/, "created")
  end

  def convert_italique_to_textile(text)
    text = text.gsub("//", "_")
    text.gsub("http:_", "http://")
  end

  def convert_bold_to_textile(text)
    text.gsub("**", "*")
  end

  def convert_highlight_to_textile(text)
    text.gsub("__", "@")
  end

  def replace_leading_newlines(text)
    text.gsub("\n\n\n", "")
  end

  def convert_first_bullet(text)
    show_regexp(text, /\t\* ([\\A-Za-z0-9"'?<>=:!?_\/\n]*)/, "first_bullet")
  end

  def convert_second_bullet(text)
    show_regexp(text, /\t\t\* ([\\A-Za-z0-9"'?<>=:!?_\/\n]*)/, "second_bullet")
  end

  def convert_third_bullet(text)
    show_regexp(text, /\t\t\t\* ([\\A-Za-z0-9"'?<>=:!?_\/\n]*)/, "third_bullet")
  end

  def convert_link_to_textile(text)
    show_regexp(text, /\[\[http[A-Za-z0-9.-:]*\|[A-Za-z.]*\]\]|http[A-Za-z0-9.-:]*/, "link")
  end

  def convert_verbatim_to_textile(text)
    show_regexp(text, /'''\n([A-Za-z0-9"'?<>!?_\t\n]*)(\n''')/, "verbatim")
  end

  def h_one_title(text)
    show_regexp(text, /====([A-Za-z0-9.:!?_\s-]*)====/, "h_one_header")
  end

  def h_two_title(text)
    show_regexp(text, /===([A-Za-z0-9.:!?_\s-]*)===\n/, "h_two_header")
  end

  def h_three_title(text)
    show_regexp(text, /==([A-Za-z0-9.:!?_\s-]*)==\n/, "h_three_header")
  end

  def convert_image(text)
    image = show_regexp(text, /\{\{([A-Za-z0-9~\/.:!?_\s-]*)\}\}/, "image")
    image = image.gsub("{{", "!")
    image = image.gsub("}}", "!")
  end

  def copy_test_file(src, dst)
    FileUtils.cp src, dst
    load_test_file(dst)
  end

  def load_test_file(file)
    File.exists?(file)
  end

  def compare_files(src, dst)
    one = File.open(src)
    two = File.open(dst)

    one_text = ""
    while line_text_one = one.gets
      one_text << line_text_one
    end

    two_text = ""
    while line_text_two = two.gets
      two_text << line_text_two
    end

    one_text == two_text
  end

  def textile_conversion(file)
    source = File.open(file)
    text = ""

    while line = source.gets
      text << apply_textile_conversion_rules(line)
    end

    replace_leading_newlines(text)
  end

  def apply_textile_conversion_rules(text)
    w = %w(remove_content_type_textile
          remove_wiki_format
          remove_creation_date
          remove_big_header
          remove_created
          h_one_title
          h_two_title
          h_three_title
          convert_link_to_textile
          convert_italique_to_textile
          convert_bold_to_textile
          convert_highlight_to_textile
          convert_image
          convert_third_bullet
          convert_second_bullet
          convert_first_bullet
          )

    tmp = text

    w.each do |function|
      converted_text = send function, tmp
      if tmp.chop == "'''"
        # tbd special routine for verbatim environment
        puts "Verbatim"
      end
      tmp = converted_text if converted_text != "no match"
    end

    tmp
  end

  def show_regexp(string, pattern, type)
    match = string.match(pattern)
    if match
      if type == "link"
       matching_string = match[0]
       if !matching_string.include?("[[")
        "#{match.pre_match}\"#{matching_string}\":#{matching_string}#{match.post_match}"
       else
        split = matching_string.split("|")
        "#{match.pre_match}\"#{split[1].gsub("]]", "\"")}#{split[0].gsub("[[", ":")}#{match.post_match}"
      end
      elsif type == "verbatim"
        "#{match[0].gsub("'''\n", "{% highlight plain %}\n").gsub("\n'''", "\n{% endhighlight %}")}"
      elsif type == "content_type"
        ""
      elsif type == "wiki_format"
        ""
      elsif type == "creation_date"
        ""
      elsif type == "big_header"
        ""
      elsif type == "created"
        ""
      elsif type == "first_bullet"
       "#{match[0].gsub("\t*", "**")}#{match.post_match}"
      elsif type == "second_bullet"
       "#{match[0].gsub("\t\t*", "***")}#{match.post_match}"
      elsif type == "third_bullet"
        "#{match[0].gsub("\t\t\t*", "****")}#{match.post_match}"
      elsif type == "h_one_header"
       "#{match[0].gsub("==== ", "h1. ").gsub("====", "")}\n\n\n"
      elsif type == "h_two_header"
       "#{match[0].gsub("=== ", "h2. ").gsub("===", "")}"
      elsif type == "h_three_header"
       "#{match[0].gsub("== ", "h3. ").gsub("==", "")}"
      elsif type == "image"
        "#{match[0].gsub("{{", "!http://").gsub("}}", "!")}"
      else
        raise "None type has been specified"
      end
    else
      "no match"
    end
  end
end

