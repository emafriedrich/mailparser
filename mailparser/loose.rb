#
# $Id$
#
# Copyright (C) 2006 TOMITA Masahiro
# mailto:tommy@tmtm.org

require "time"
require "strscan"
require "mailparser/rfc2822"
require "mailparser/rfc2045"

module MailParser
  module Loose
    HEADER_PARSER = {
      "date"                      => :parse_date,
      "from"                      => :parse_mailbox_list,
      "sender"                    => :parse_mailbox,
      "reply-to"                  => :parse_mailbox_list,
      "to"                        => :parse_mailbox_list,
      "cc"                        => :parse_mailbox_list,
      "bcc"                       => :parse_mailbox_list,
      "message-id"                => :parse_msg_id,
      "in-reply-to"               => :parse_msg_id_list,
      "references"                => :parse_msg_id_list,
      "keywords"                  => :parse_phrase_list,
      "resent-date"               => :parse_date,
      "resent-from"               => :parse_mailbox_list,
      "resent-sender"             => :parse_mailbox,
      "resent-to"                 => :parse_mailbox_list,
      "resent-cc"                 => :parse_mailbox_list,
      "resent-bcc"                => :parse_mailbox_list,
      "resent-message-id"         => :parse_msg_id,
      "return-path"               => :parse_return_path,
      "received"                  => :parse_received,
      "content-type"              => :parse_content_type,
      "content-transfer-encoding" => :parse_content_transfer_encoding,
      "content-id"                => :parse_msg_id,
      "mime-version"              => :parse_mime_version,
      "content-disposition"       => :parse_content_disposition,
    }

    module_function
    # ヘッダをパースした結果のオブジェクトを返す
    # hname:: ヘッダ名(String)
    # hbody:: ヘッダ本文(String)
    # opt:: オプション(Hash)
    def parse(hname, hbody, opt)
      if HEADER_PARSER.key? hname then
        return method(HEADER_PARSER[hname]).call(hbody, opt)
      else
        r = hbody.gsub(/\s+/, " ")
        if opt[:decode_mime_header] then
          return RFC2047.decode(r, opt[:output_charset])
        else
          return r
        end
      end
    end

    # Date ヘッダをパースして、RFC2822::DateTime を返す
    def parse_date(str, opt={})
      begin
        t = Time.rfc2822(str) rescue Time.parse(str)
      rescue
        t = Time.now
      end
      return RFC2822::DateTime.new(t.year, t.month, t.day, t.hour, t.min, t.sec, t.zone)
    end

    # From,To,Cc 等のヘッダをパースして RFC2822::Mailbox の配列を返す
    def parse_mailbox_list(str, opt)
      mailbox_list(str)
    end

    # Sender,Resent-Sender ヘッダをパースして RFC2822::Mailbox を返す
    def parse_mailbox(str, opt)
      mailbox_list(str)[0]
    end

    # Message-Id,Resent-Message-Id ヘッダをパースして RFC2822::MsgId を返す
    def parse_msg_id(str, opt)
      msg_id_list(str)[0]
    end

    # In-Reply-To,References 等のヘッダを RFC2822::MsgIdList を返す
    def parse_msg_id_list(str, opt)
      msg_id_list(str)
    end

    # Keywords ヘッダをパースして文字列の配列を返す
    def parse_phrase_list(str, opt)
      split_by(Tokenizer.token(str), ",").map{|i| i.to_s}
    end

    # Return-Path ヘッダをパースして RFC2822:ReturnPath を返す
    def parse_return_path(str, opt)
      mailbox_list(str)[0]
    end

    # Received ヘッダをパースして RFC2822::Received を返す
    def parse_received(str, opt)
      a = split_by(Tokenizer.token_received(str), ";")
      date = parse_date(a[-1].join(" "))
      name_val = {}
      i = 0
      v = ""
      while i < a[0].length do
        if a[0][i] =~ /\A[a-z0-9]+\z/ino then
          v = a[0][i+1]
          name_val[a[0][i]] = v
          i += 1
        else
          v << a[0][i]
        end
        i += 1
      end
      RFC2822::Received.new(name_val, date)
    end

    # Content-Type ヘッダをパースして RFC2045::ContentType を返す
    def parse_content_type(str, opt)
      token = split_by(Tokenizer.token(str), ";")
      type, subtype = token[0].to_s.split("/", 2)
      params = {}
      token[1..-1].map do |param|
        pn, pv = param.to_s.split(/=/, 2)
        params[pn.to_s] = pv.to_s.gsub(/\A"|"\z/,"")
      end
      RFC2045::ContentType.new(type.to_s, subtype.to_s, params)
    end

    # Content-Transfer-Encoding ヘッダをパースして RFC2045::ContentTransferEncoding を返す
    def parse_content_transfer_encoding(str, opt)
      RFC2045::ContentTransferEncoding.new(Tokenizer.token(str)[0])
    end

    # Mime-Version ヘッダをパースして文字列を返す
    def parse_mime_version(str, opt)
      Tokenizer.token(str).join
    end

    # Content-Disposition ヘッダをパースして RFC2183::ContentDisposition を返す
    def parse_content_distribution(str, opt)
      token = split_by(Tokenizer.token(str), ";")
      type = token[0].to_s
      params = {}
      token[1..-1].map do |param|
        pn, pv = param.to_s.split(/=/, 2)
        params[pn.to_s] = pv.to_s.gsub(/\A"|"\z/,"")
      end
      RFC2045::ContentType.new(type, params)
    end

    # array を delim で分割した配列(要素は配列)を返す
    def split_by(array, delim)
      ret = []
      a = []
      array.each do |i|
        if i == delim then
          ret << a
          a = []
        else
          a << i
        end
      end
      ret << a unless a.empty?
      return ret
    end

    # Mailbox のリストを返す
    def mailbox_list(str)
      ret = []
      split_by(Tokenizer.token(str), ",").each do |m|
        if a1 = m.index("<") and a2 = m.rindex(">") and a2 > a1 then
          display_name = m[0..a1-1].join(" ")
          mailaddr = m[a1+1..a2-1].to_s
          local_part, domain = mailaddr.split(/@/, 2)
          ret << RFC2822::Mailbox.new(RFC2822::AddrSpec.new(local_part, domain), display_name)
        else
          local_part, domain = m.to_s.split(/@/, 2)
          ret << RFC2822::Mailbox.new(RFC2822::AddrSpec.new(local_part, domain))
        end
      end
      return ret
    end

    # MsgId のリストを返す
    def msg_id_list(str)
      ret = []
      split_by(Tokenizer.token(str), ",").each do |m|
        if a1 = m.index("<") and a2 = m.rindex(">") and a2 > a1 then
          msgid = m[a1+1..a2-1].to_s
          ret << RFC2822::MsgId.new(msgid)
        else
          ret << RFC2822::MsgId.new(m.to_s)
        end
      end
      return ret
    end

    class Tokenizer < RFC2822::Scanner
      def initialize(str)
        @comments = []
        @ss = StringScanner.new(str)
      end

      # トークンに分割(コメント部は削除)
      def token()
        token = []
        while @ss.rest? do
          if s = @ss.scan(/\s+/nmo) then
            # ignore
          elsif s = @ss.scan(/\(/nmo) then
            begin
              pos = @ss.pos
              cfws(@ss)
            rescue ParseError
              @ss.pos = pos
              token << s
            end
          elsif s = @ss.scan(/\"(\s*(\\[#{TEXT_RE}]|[#{QTEXT_RE}]))*\s*\"/nmo) ||
              @ss.scan(/\[(\s*(\\[#{TEXT_RE}]|[#{DTEXT_RE}]))*\s*\]/nmo) ||
              @ss.scan(/[#{ATEXT_RE}]+/no)
            token << s
          else
            token << @ss.scan(/./no)
          end
        end
        return token
      end

      # Received 用に分割
      def token_received()
        ret = []
        while @ss.rest? do
          if s = @ss.scan(/\s+/nmo) then
            # ignore blank
          elsif s = @ss.scan(/\(/nmo) then
            begin
              pos = @ss.pos
              cfws(@ss)
            rescue ParseError
              @ss.pos = pos
              ret.last << s unless ret.empty?
            end
          elsif s = @ss.scan(/\"(\s*(\\[#{TEXT_RE}]|[#{QTEXT_RE}]))*\s*\"/nmo)
            ret << s
          elsif s = @ss.scan(/;/)
            ret << s
          else
            ret << @ss.scan(/[^\s\(\;]+/nmo)
          end
        end
        return ret
      end

      def self.token(str)
        Tokenizer.new(str).token
      end

      def self.token_received(str)
        Tokenizer.new(str).token_received
      end
    end

  end
end
