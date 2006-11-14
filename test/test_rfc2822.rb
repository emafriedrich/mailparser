#
# $Id$
#
# Copyright (C) 2006 TOMITA Masahiro
# mailto:tommy@tmtm.org

require "mailparser/rfc2822"

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
          MailParser::RFC2822.parse(*h.split(/\s*:\s*/, 2))
        rescue MailParser::RFC2822::ParseError => e
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

class TC_RFC2822Parser < Test::Unit::TestCase
  def setup()
    @p = MailParser::RFC2822::Parser.new()
  end
  def teardown()
  end

  def test_mailbox_list()
    m = @p.parse(:MAILBOX_LIST, "a@b.c")
    assert_equal(1, m.size)
    assert_kind_of(MailParser::RFC2822::Mailbox, m[0])
    assert_equal("<a@b.c>", m[0].to_s)
    m = @p.parse(:MAILBOX_LIST, "hoge <a@b.c>")
    assert_equal(1, m.size)
    assert_kind_of(MailParser::RFC2822::Mailbox, m[0])
    assert_equal("hoge <a@b.c>", m[0].to_s)
    m = @p.parse(:MAILBOX_LIST, "hoge <a@b.c>, d@e.f")
    assert_equal(2, m.size)
    assert_kind_of(MailParser::RFC2822::Mailbox, m[0])
    assert_kind_of(MailParser::RFC2822::Mailbox, m[1])
    assert_equal("hoge <a@b.c>", m[0].to_s)
    assert_equal("<d@e.f>", m[1].to_s)
  end

  def test_mailbox()
    m = @p.parse(:MAILBOX, "a@b.c")
    assert_equal("", m.display_name.to_s)
    assert_equal("a@b.c", m.addr_spec.to_s)
    m = @p.parse(:MAILBOX, "hoge <a@b.c>")
    assert_equal("hoge", m.display_name.to_s)
    assert_equal("a@b.c", m.addr_spec.to_s)
    m = @p.parse(:MAILBOX, "hoge fuga <a@b.c>")
    assert_equal("hoge fuga", m.display_name)
    assert_equal("a@b.c", m.addr_spec.to_s)
  end

  def test_address_list()
    a = @p.parse(:ADDRESS_LIST, "a@b.c")
    assert_equal(1, a.size)
    assert_kind_of(MailParser::RFC2822::Mailbox, a[0])
    assert_equal("<a@b.c>", a[0].to_s)
    a = @p.parse(:ADDRESS_LIST, "group:;, hoge <a@b.c>")
    assert_equal(2, a.size)
    assert_kind_of(MailParser::RFC2822::Group, a[0])
    assert_kind_of(MailParser::RFC2822::Mailbox, a[1])
    assert_equal("group:;", a[0].to_s)
    assert_equal("hoge <a@b.c>", a[1].to_s)
    a = @p.parse(:ADDRESS_LIST, "group: a@b.c, hoge <d@e.f>;")
    assert_equal(1, a.size)
    assert_kind_of(MailParser::RFC2822::Group, a[0])
    assert_kind_of(Array, a[0].mailbox_list)
    assert_equal(2, a[0].mailbox_list.size)
    assert_kind_of(MailParser::RFC2822::Mailbox, a[0].mailbox_list[0])
    assert_kind_of(MailParser::RFC2822::Mailbox, a[0].mailbox_list[1])
    assert_equal("group:<a@b.c>,hoge <d@e.f>;", a[0].to_s)
  end

  def test_address_list_bcc()
    a = @p.parse(:ADDRESS_LIST_BCC, "")
    assert_equal(0, a.size)
    a = @p.parse(:ADDRESS_LIST_BCC, "a@b.c")
    assert_equal(1, a.size)
    assert_kind_of(MailParser::RFC2822::Mailbox, a[0])
    assert_equal("<a@b.c>", a[0].to_s)
    a = @p.parse(:ADDRESS_LIST_BCC, "group:;, hoge <a@b.c>")
    assert_equal(2, a.size)
    assert_kind_of(MailParser::RFC2822::Group, a[0])
    assert_kind_of(MailParser::RFC2822::Mailbox, a[1])
    assert_equal("group:;", a[0].to_s)
    assert_equal("hoge <a@b.c>", a[1].to_s)
    a = @p.parse(:ADDRESS_LIST_BCC, "group: a@b.c, hoge <d@e.f>;")
    assert_equal(1, a.size)
    assert_kind_of(MailParser::RFC2822::Group, a[0])
    assert_kind_of(Array, a[0].mailbox_list)
    assert_equal(2, a[0].mailbox_list.size)
    assert_kind_of(MailParser::RFC2822::Mailbox, a[0].mailbox_list[0])
    assert_kind_of(MailParser::RFC2822::Mailbox, a[0].mailbox_list[1])
    assert_equal("group:<a@b.c>,hoge <d@e.f>;", a[0].to_s)
  end

  def test_msg_id()
    m = @p.parse(:MSG_ID, "<a@b.c>")
    assert_kind_of(MailParser::RFC2822::MsgId, m)
    assert_equal("<a@b.c>", m.to_s)
  end

  def test_msg_id_list()
    m = @p.parse(:MSG_ID_LIST, "<a@b.c>")
    assert_equal(1, m.size)
    assert_kind_of(MailParser::RFC2822::MsgId, m[0])
    assert_equal("<a@b.c>", m.to_s)
    m = @p.parse(:MSG_ID_LIST, "<a@b.c> <d@e.f>")
    assert_kind_of(Array, m)
    assert_equal(2, m.size)
    assert_kind_of(MailParser::RFC2822::MsgId, m[0])
    assert_kind_of(MailParser::RFC2822::MsgId, m[1])
    assert_equal("<a@b.c> <d@e.f>", m.to_s)
  end

  def test_phrase_list()
    p = @p.parse(:PHRASE_LIST, "hoge")
    assert_kind_of(Array, p)
    assert_equal(["hoge"], p)
    p = @p.parse(:PHRASE_LIST, "hoge,fuga hage")
    assert_equal(2, p.size)
    assert_equal("hoge", p[0])
    assert_equal("fuga hage", p[1])
  end

  def test_date_time_jst()
    d = @p.parse(:DATE_TIME, "25 Sep 2006 01:23:56 +0900")
    assert_equal(2006, d.year)
    assert_equal(9, d.month)
    assert_equal(25, d.day)
    assert_equal(1, d.hour)
    assert_equal(23, d.min)
    assert_equal(56, d.sec)
    assert_equal("+0900", d.zone)
    assert_equal(Time.utc(2006,9,24,16,23,56), d.time)
  end

  def test_date_time_edt()
    d = @p.parse(:DATE_TIME, "25 Sep 2006 01:23:56 -0400")
    assert_equal(2006, d.year)
    assert_equal(9, d.month)
    assert_equal(25, d.day)
    assert_equal(1, d.hour)
    assert_equal(23, d.min)
    assert_equal(56, d.sec)
    assert_equal("-0400", d.zone)
    assert_equal(Time.utc(2006,9,25,5,23,56), d.time)
  end
end

class TC_AddrSpec < Test::Unit::TestCase
  def test_new()
    a = MailParser::RFC2822::AddrSpec.new("local", "domain") 
    assert_equal("local", a.local_part)
    assert_equal("domain", a.domain)
    assert_equal("local@domain", a.to_s)
  end
end

class TC_Mailbox < Test::Unit::TestCase
  def test_new()
    m = MailParser::RFC2822::Mailbox.new("local@domain", "phrase")
    assert_equal("local@domain", m.addr_spec)
    assert_equal("phrase", m.display_name)
    assert_equal("phrase", m.phrase)
    assert_equal("phrase <local@domain>", m.to_s)
  end

  def test_new_no_phrase()
    m = MailParser::RFC2822::Mailbox.new("local@domain")
    assert_equal("local@domain", m.addr_spec)
    assert_equal("", m.display_name)
    assert_equal("", m.phrase)
    assert_equal("<local@domain>", m.to_s)
  end
end

class TC_DateTime < Test::Unit::TestCase
  def test_new_int()
    d = MailParser::RFC2822::DateTime.new(2006, 9, 25, 23, 56, 10, "+0900")
    assert_equal(2006, d.year)
    assert_equal(9, d.month)
    assert_equal(25, d.day)
    assert_equal(23, d.hour)
    assert_equal(56, d.min)
    assert_equal(10, d.sec)
    assert_equal("+0900", d.zone)
    assert_equal(Time.utc(2006,9,25,14,56,10), d.time)
  end

  def test_new_str()
    d = MailParser::RFC2822::DateTime.new("2006", "9", "25", "23", "56", "10", "+0900")
    assert_equal(2006, d.year)
    assert_equal(9, d.month)
    assert_equal(25, d.day)
    assert_equal(23, d.hour)
    assert_equal(56, d.min)
    assert_equal(10, d.sec)
    assert_equal("+0900", d.zone)
    assert_equal(Time.utc(2006,9,25,14,56,10), d.time)
  end

  def test_new_obsolete_zone()
    d = MailParser::RFC2822::DateTime.new("2006", "9", "25", "23", "56", "10", "GMT")
    assert_equal(2006, d.year)
    assert_equal(9, d.month)
    assert_equal(25, d.day)
    assert_equal(23, d.hour)
    assert_equal(56, d.min)
    assert_equal(10, d.sec)
    assert_equal("+0000", d.zone)
    assert_equal(Time.utc(2006,9,25,23,56,10), d.time)
  end

  def test_new_unknown_zone()
    d = MailParser::RFC2822::DateTime.new("2006", "9", "25", "23", "56", "10", "xxx")
    assert_equal(2006, d.year)
    assert_equal(9, d.month)
    assert_equal(25, d.day)
    assert_equal(23, d.hour)
    assert_equal(56, d.min)
    assert_equal(10, d.sec)
    assert_equal("-0000", d.zone)
    assert_equal(Time.utc(2006,9,25,23,56,10), d.time)
  end
end
