#
# $Id$
#
# Copyright (C) 2006 TOMITA Masahiro
# mailto:tommy@tmtm.org

require "rfc2045"

unless ARGV.empty?
  ARGV.each do |fname|
    File.open(fname) do |f|
      header = []
      f.each do |line|
        break if line.chomp.empty?
        if line =~ /^\s/ then
          header[-1] << line
        else
          header << line
        end
      end
      header.each do |h|
        begin
          RFC2045.parse(*h.split(/\s*:\s*/, 2))
        rescue RFC2045::ParseError => e
          puts fname
          p e
          p h
        end
      end
    end
  end
  exit
end

require "test/unit"

class TC_RFC2045 < Test::Unit::TestCase
  def test_content_type_noparams()
    c = RFC2045.parse("content-type", "text/plain")
    assert_equal("text", c.type)
    assert_equal("plain", c.subtype)
    assert_equal({}, c.params)
  end

  def test_content_type_charset()
    c = RFC2045.parse("content-type", "text/plain; charset=euc-jp")
    assert_equal("text", c.type)
    assert_equal("plain", c.subtype)
    assert_equal(1, c.params.size)
    assert_equal("euc-jp", c.params["charset"])
  end

  def test_content_type_charset_upcase()
    c = RFC2045.parse("content-type", "TEXT/PLAIN; CHARSET=euc-jp")
    assert_equal("text", c.type)
    assert_equal("plain", c.subtype)
    assert_equal(1, c.params.size)
    assert_equal("euc-jp", c.params["charset"])
  end

  def test_content_type_charset_quote()
    c = RFC2045.parse("content-type", "text/plain; charset=\"euc-jp\"")
    assert_equal("text", c.type)
    assert_equal("plain", c.subtype)
    assert_equal(1, c.params.size)
    assert_equal("euc-jp", c.params["charset"])
  end

  def test_content_description()
    c = RFC2045.parse("content-description", "(hoge fuga>")
    assert_equal("(hoge fuga>", c)
  end

  def test_content_transfer_encoding()
    c = RFC2045.parse("content-transfer-encoding", "7bit")
    assert_equal("7bit", c.mechanism)
  end

  def test_content_id()
    c = RFC2045.parse("content-id", "<a@b.c>")
    assert_equal("a@b.c", c.msg_id)
  end

  def test_mime_version()
    v = RFC2045.parse("mime-version", "1.0")
    assert_equal("1.0", v)
  end

  def test_mime_version_with_comment()
    v = RFC2045.parse("mime-version", "1.0 (hoge)")
    assert_equal("1.0", v)
  end

  def test_mime_version_with_comment2()
    v = RFC2045.parse("mime-version", "1.(hoge)0")
    assert_equal("1.0", v)
  end

  def test_qp_decode()
    assert_equal("IJKL", RFC2045.qp_decode("=49=4A=4B=4C"))
    assert_equal("IJKL", RFC2045.qp_decode("=49=4a=4b=4c"))
    assert_equal("abcdefg", RFC2045.qp_decode("abcd=\r\nefg"))
    assert_equal("abcdefg", RFC2045.qp_decode("abcd=  \r\nefg"))
    assert_equal("abcdefg", RFC2045.qp_decode("abcd=\nefg"))
    assert_equal("abcdefg", RFC2045.qp_decode("abcd=  \nefg"))
  end

  def test_b64_decode()
    assert_equal("abcdefg", RFC2045.b64_decode("YWJjZGVmZw=="))
    assert_equal("01234567890123456789", RFC2045.b64_decode("MDEyMzQ1Njc4OTAxMjM0NTY3ODk="))
    assert_equal("01234567890123456789", RFC2045.b64_decode("MDEyMzQ1Njc4\nOTAxMjM0NTY3ODk="))
    assert_equal("01234567890123456789", RFC2045.b64_decode("MDEyMzQ1Nj\nc4OTAxMjM0NTY3ODk="))
  end
end

