#
# $Id$
#
# Copyright (C) 2006 TOMITA Masahiro
# mailto:tommy@tmtm.org

class RFC2045::Parser

  options no_result_var

rule

all             : CONTENT_TYPE content_type {val[1]}
#               | CONTENT_DESCRIPTION
                | CONTENT_TRANSFER_ENCODING content_transfer_encoding {val[1]}
#               | CONTENT_ID content_id {val[1]}
                | MIME_VERSION mime_version {val[1]}

content_type    : type '/' subtype parameter_list
                  {
                    ContentType.new(val[0], val[2], val[3])
                  }

content_transfer_encoding: mechanism
                  {
                    ContentTransferEncoding.new(val[0])
                  }

#content_id      : msg_id

mime_version    : DIGIT '.' DIGIT
                  {
                    val.join
                  }

mechanism       : TOKEN

type            : TOKEN

subtype         : TOKEN

parameter_list  : /* empty */
                  {
                    {}
                  }
                | parameter_list ';' parameter
                  {
                    pn, pv = val[2]
                    pv = $1 if pv =~ /\A\"(.*)\"\Z/
                    val[0][pn] = pv
                    val[0]
                  }

parameter       : attribute '=' value
                  {
                    [val[0].downcase, val[2]]
                  }

attribute       : TOKEN

value           : TOKEN
                | QUOTED_STRING

---- inner

require "rfc2045/scanner"

def parse(header_type, value)
  @header_type = header_type
  @value = value
  @scanner = RFC2045::Scanner.new(header_type, value)
  ret = yyparse(self, :parse_sub)
  @comments = @scanner.comments
  ret
end

def parse_sub(&block)
  yield @header_type, @value
  @scanner.scan(&block)
end

def on_error(t, val, vstack)
#  p t, val, vstack
#  p racc_token2str(t)
  raise ParseError, val
end
