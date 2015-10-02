# coding: ascii-8bit
#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.12
# from Racc grammer file "".
#

require 'racc/parser.rb'
module MailParser
  module RFC2822
    class Parser < Racc::Parser

module_eval(<<'...end parser.y/module_eval...', 'parser.y', 346)

require "mailparser/rfc2822/scanner"

def initialize(opt={})
  @opt = opt
  super()
end

def parse(header_type, value)
  @header_type = header_type
  @value = value
  @last_id = nil
  @comma_list = []
  @scanner = Scanner.new(header_type, value)
  ret = yyparse(self, :parse_sub)
  return if ret.nil?
  class << ret
    attr_accessor :comments
  end
  ret.comments = decode2(@scanner.comments)
  ret
end

def parse_sub(&block)
  yield [@header_type, nil]
  @scanner.scan(&block)
end

def on_error(t, val, vstack)
#  p t, val, vstack
#  p racc_token2str(t)
  raise MailParser::ParseError, val+@scanner.rest
end

def decode(s)
  return s unless @opt[:decode_mime_header]
  RFC2047.decode(s, @opt)
end

def decode2(ary)
  ary.map{|i| decode(i)}
end
...end parser.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,
    12,    13,    23,    97,   130,   -57,    99,    23,   129,    33,
    34,    84,    35,    36,    33,    34,    23,    35,    36,   -57,
    23,    23,    87,    33,    34,   113,    35,    36,    33,    34,
    47,    35,    36,    33,    34,    23,    14,    33,    34,    47,
    35,    36,    33,    34,    23,    35,    36,    47,    57,    23,
    59,    33,    34,    63,    35,    36,    33,    34,    23,    35,
    36,    64,    65,   109,   110,    33,    34,    23,    35,    36,
    96,    76,    70,    77,    84,    85,    33,    34,    70,    35,
    36,    86,    33,    34,    47,    35,    36,    33,    34,    91,
    35,    36,    33,    34,    94,    35,    36,    33,    34,    80,
    35,    36,    33,    34,    95,    35,    36,    33,    34,   101,
    35,    36,    33,    34,   103,    35,    36,    33,    34,    76,
    35,    36,    33,    34,   112,    35,    36,    33,    34,   113,
    35,    36,    33,    34,   114,    35,    36,   109,   110,    33,
    34,   109,   110,    33,    34,   109,   110,    33,    34,   109,
   110,    33,    34,   117,   119,    57,   128,    84,   132,   135,
    23,   113,   139,   141,   143,   144,   145,   146,   147 ]

racc_action_check = [
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     2,    62,   104,   124,    62,     3,   104,     2,
     2,   124,     2,     2,     3,     3,     4,     3,     3,   137,
    44,     5,    44,     4,     4,   137,     4,     4,     5,     5,
    54,     5,     5,   107,   107,    65,     1,    54,    54,     6,
    54,    54,    65,    65,    86,    65,    65,     7,    10,    87,
    11,    86,    86,    13,    86,    86,    87,    87,    99,    87,
    87,    14,    16,    99,    99,    99,    99,    22,    99,    99,
    59,    25,    59,    26,    31,    32,    59,    59,    23,    59,
    59,    39,    23,    23,    48,    23,    23,     8,     8,    50,
     8,     8,    24,    24,    56,    24,    24,    29,    29,    29,
    29,    29,    30,    30,    57,    30,    30,    47,    47,    67,
    47,    47,    52,    52,    69,    52,    52,    68,    68,    71,
    68,    68,    72,    72,    79,    72,    72,    91,    91,    82,
    91,    91,   123,   123,    83,   123,   123,    70,    70,    70,
    70,    76,    76,    76,    76,   117,   117,   117,   117,   129,
   129,   129,   129,    88,    94,    97,   102,   106,   116,   119,
   122,   131,   133,   135,   140,   141,   144,   145,   146 ]

racc_action_pointer = [
    -2,    46,    -3,     2,    11,    16,    34,    42,    75,   nil,
    36,    45,   nil,    50,    71,   nil,    58,   nil,   nil,   nil,
   nil,   nil,    62,    70,    80,    63,    59,   nil,   nil,    85,
    90,    60,    61,   nil,   nil,   nil,   nil,   nil,   nil,    77,
   nil,   nil,   nil,   nil,    15,   nil,   nil,    95,    79,   nil,
    85,   nil,   100,   nil,    25,   nil,    81,   100,   nil,    64,
   nil,   nil,    -6,   nil,   nil,    30,   nil,   103,   105,   107,
   127,   111,   110,   nil,   nil,   nil,   131,   nil,   nil,   110,
   nil,   nil,   115,   120,   nil,   nil,    39,    44,   145,   nil,
   nil,   115,   nil,   nil,   142,   nil,   nil,   143,   nil,    53,
   nil,   nil,   150,   nil,     0,   nil,   143,    21,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   149,   135,   nil,   146,
   nil,   nil,   155,   120,    -3,   nil,   nil,   nil,   nil,   139,
   nil,   147,   nil,   156,   nil,   150,   nil,    11,   nil,   nil,
   152,   158,   nil,   nil,   153,   160,   155,   nil ]

racc_action_default = [
   -93,   -93,   -16,   -93,   -21,   -21,   -93,   -93,   -42,   -73,
   -88,   -93,   -81,   -93,   -93,    -1,   -13,   -14,   -17,   -25,
   -26,   -27,   -93,   -93,   -39,   -44,   -45,   -46,   -49,   -93,
   -93,   -57,   -58,   -59,   -60,   -68,   -69,    -2,    -3,   -18,
   -19,   -22,   -23,   -24,   -93,    -4,    -5,   -93,    -6,   -70,
    -7,   -40,   -43,   -44,    -8,    -9,   -93,   -93,   -10,   -93,
   -79,   -11,   -93,   -12,   148,   -16,   -28,   -93,   -93,   -36,
   -93,   -93,   -93,   -47,   -57,   -58,   -93,   -65,   -50,   -58,
   -64,   -51,   -57,   -58,   -66,   -61,   -21,   -16,   -93,   -76,
   -71,   -42,   -74,   -75,   -93,   -89,   -78,   -88,   -82,   -93,
   -15,   -31,   -93,   -33,   -93,   -34,   -52,   -93,   -54,   -55,
   -56,   -48,   -62,   -67,   -63,   -20,   -93,   -93,   -41,   -93,
   -80,   -29,   -84,   -93,   -52,   -83,   -85,   -86,   -32,   -93,
   -37,   -53,   -38,   -93,   -77,   -93,   -30,   -53,   -35,   -72,
   -93,   -93,   -87,   -92,   -93,   -90,   -93,   -91 ]

racc_goto_table = [
    60,    74,    55,    73,    53,    15,    74,    82,    78,    81,
    75,    66,     1,    52,    51,    79,    83,    44,    44,    71,
    37,    42,    42,    46,    49,    67,    38,    45,    48,    74,
    50,    73,    72,    66,   105,    54,    58,    61,    75,   100,
   111,   115,   122,    89,   104,    92,    88,   106,   133,    74,
    53,    78,    62,   106,    98,    71,    72,   125,    79,   140,
   142,    67,   nil,   127,    71,    90,   nil,   nil,    72,   107,
   102,    93,   nil,   nil,   nil,   107,   124,    72,   nil,   nil,
   nil,   134,   nil,   nil,   131,   nil,   nil,    53,   121,   120,
   116,   nil,   nil,   138,   106,    71,    52,   118,   123,    44,
   137,   126,    81,    42,   nil,   nil,   106,   nil,    72,    83,
   nil,   136,   nil,   nil,   nil,   nil,   107,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   107 ]

racc_goto_check = [
    20,    35,     9,    32,    30,     2,    35,    35,    32,    32,
    37,    20,     1,    27,    28,    37,    37,    21,    21,    30,
     3,     3,     3,     5,     5,    19,     4,     4,     6,    35,
     7,    32,    33,    20,    25,     8,    10,    11,    37,    13,
    25,    15,    22,    30,    26,    29,    38,    35,    39,    35,
    30,    32,    40,    35,    41,    30,    33,    42,    37,    44,
    45,    19,   nil,    25,    30,     5,   nil,   nil,    33,    34,
    19,     5,   nil,   nil,   nil,    34,    35,    33,   nil,   nil,
   nil,    25,   nil,   nil,    35,   nil,   nil,    30,    20,     9,
     2,   nil,   nil,    25,    35,    30,    27,    28,    34,    21,
    35,    19,    32,     3,   nil,   nil,    35,   nil,    33,    37,
   nil,    20,   nil,   nil,   nil,   nil,    34,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    34 ]

racc_goto_pointer = [
   nil,    12,     3,    17,    22,    17,    21,    22,    26,    -8,
    25,    25,   nil,   -26,   nil,   -45,   nil,   nil,   nil,     2,
   -11,    13,   -57,   nil,   nil,   -36,   -25,     5,     6,    -9,
    -4,   nil,   -21,     9,    -1,   -23,   nil,   -14,    -1,   -69,
    40,    -8,   -42,   nil,   -76,   -80 ]

racc_goto_default = [
   nil,   nil,   nil,    18,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,    16,    17,    39,    40,    41,    43,    19,    20,
    21,    22,   nil,    68,    69,   nil,   nil,    24,   nil,    27,
    25,    26,    28,    29,    30,    31,   108,    32,   nil,   nil,
   nil,   nil,   nil,    56,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  2, 28, :_reduce_1,
  2, 28, :_reduce_2,
  2, 28, :_reduce_3,
  2, 28, :_reduce_4,
  2, 28, :_reduce_5,
  2, 28, :_reduce_6,
  2, 28, :_reduce_7,
  2, 28, :_reduce_8,
  2, 28, :_reduce_9,
  2, 28, :_reduce_10,
  2, 28, :_reduce_11,
  2, 28, :_reduce_12,
  1, 29, :_reduce_13,
  1, 39, :_reduce_14,
  3, 39, :_reduce_15,
  0, 40, :_reduce_none,
  1, 40, :_reduce_none,
  1, 31, :_reduce_18,
  1, 41, :_reduce_19,
  3, 41, :_reduce_20,
  0, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 30, :_reduce_none,
  1, 30, :_reduce_26,
  1, 45, :_reduce_27,
  2, 45, :_reduce_28,
  1, 49, :_reduce_29,
  2, 49, :_reduce_30,
  3, 47, :_reduce_31,
  4, 47, :_reduce_32,
  2, 50, :_reduce_none,
  2, 51, :_reduce_none,
  4, 51, :_reduce_none,
  0, 53, :_reduce_none,
  2, 53, :_reduce_none,
  4, 44, :_reduce_38,
  1, 48, :_reduce_39,
  1, 34, :_reduce_40,
  3, 34, :_reduce_41,
  0, 55, :_reduce_none,
  1, 55, :_reduce_43,
  1, 56, :_reduce_none,
  1, 56, :_reduce_none,
  1, 54, :_reduce_46,
  2, 54, :_reduce_47,
  3, 46, :_reduce_48,
  1, 57, :_reduce_none,
  2, 57, :_reduce_50,
  2, 57, :_reduce_51,
  1, 52, :_reduce_none,
  2, 52, :_reduce_53,
  1, 52, :_reduce_none,
  1, 63, :_reduce_none,
  1, 63, :_reduce_none,
  1, 59, :_reduce_none,
  1, 59, :_reduce_none,
  1, 62, :_reduce_none,
  1, 62, :_reduce_none,
  2, 60, :_reduce_61,
  3, 60, :_reduce_62,
  3, 60, :_reduce_63,
  2, 58, :_reduce_64,
  2, 58, :_reduce_65,
  2, 61, :_reduce_66,
  3, 61, :_reduce_67,
  1, 64, :_reduce_none,
  1, 64, :_reduce_none,
  1, 33, :_reduce_70,
  2, 33, :_reduce_71,
  5, 32, :_reduce_72,
  0, 35, :_reduce_73,
  2, 35, :_reduce_none,
  2, 35, :_reduce_75,
  1, 65, :_reduce_none,
  1, 66, :_reduce_none,
  2, 37, :_reduce_78,
  1, 37, :_reduce_none,
  3, 38, :_reduce_80,
  0, 67, :_reduce_81,
  2, 67, :_reduce_82,
  2, 68, :_reduce_83,
  1, 69, :_reduce_none,
  1, 69, :_reduce_none,
  1, 69, :_reduce_none,
  6, 36, :_reduce_87,
  0, 70, :_reduce_none,
  2, 70, :_reduce_89,
  3, 71, :_reduce_90,
  5, 71, :_reduce_91,
  1, 72, :_reduce_92 ]

racc_reduce_n = 93

racc_shift_n = 148

racc_token_table = {
  false => 0,
  :error => 1,
  :MAILBOX_LIST => 2,
  :MAILBOX => 3,
  :ADDRESS_LIST => 4,
  :ADDRESS_LIST_BCC => 5,
  :MSG_ID => 6,
  :MSG_ID_LIST => 7,
  :PHRASE_LIST => 8,
  :PHRASE_MSG_ID_LIST => 9,
  :DATE_TIME => 10,
  :RETURN_PATH => 11,
  :RECEIVED => 12,
  :UNSTRUCTURED => 13,
  "," => 14,
  "<" => 15,
  ">" => 16,
  ":" => 17,
  "@" => 18,
  ";" => 19,
  :DOMAIN_LITERAL => 20,
  :NO_FOLD_LITERAL => 21,
  :ATOM => 22,
  :DIGIT => 23,
  "." => 24,
  :QUOTED_STRING => 25,
  :NO_FOLD_QUOTE => 26 }

racc_nt_base = 27

racc_use_result_var = false

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "MAILBOX_LIST",
  "MAILBOX",
  "ADDRESS_LIST",
  "ADDRESS_LIST_BCC",
  "MSG_ID",
  "MSG_ID_LIST",
  "PHRASE_LIST",
  "PHRASE_MSG_ID_LIST",
  "DATE_TIME",
  "RETURN_PATH",
  "RECEIVED",
  "UNSTRUCTURED",
  "\",\"",
  "\"<\"",
  "\">\"",
  "\":\"",
  "\"@\"",
  "\";\"",
  "DOMAIN_LITERAL",
  "NO_FOLD_LITERAL",
  "ATOM",
  "DIGIT",
  "\".\"",
  "QUOTED_STRING",
  "NO_FOLD_QUOTE",
  "$start",
  "all",
  "mailbox_list",
  "mailbox",
  "address_list",
  "msg_id",
  "msg_id_list",
  "phrase_list",
  "phrase_msg_id_list",
  "date_time",
  "return_path",
  "received",
  "mailbox_list_",
  "mailbox_opt",
  "address_list_",
  "address_opt",
  "address",
  "group",
  "name_addr",
  "addr_spec",
  "angle_addr",
  "display_name",
  "angle_addr_list",
  "obs_route",
  "obs_domain_list",
  "domain",
  "obs_domain_list_delim",
  "phrase",
  "phrase_opt",
  "phrase0",
  "local_part",
  "word_dot_list_dot",
  "word",
  "word_dot_list",
  "atom_dot_list",
  "atom",
  "domain_literal",
  "quoted_string",
  "id_left",
  "id_right",
  "name_val_list",
  "name_val_pair",
  "item_value",
  "day_of_week",
  "time_of_day",
  "zone" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'parser.y', 9)
  def _reduce_1(val, _values)
    val[1]
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 10)
  def _reduce_2(val, _values)
    val[1]
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 11)
  def _reduce_3(val, _values)
    val[1]
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 12)
  def _reduce_4(val, _values)
    val[1]
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 13)
  def _reduce_5(val, _values)
    val[1]
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 14)
  def _reduce_6(val, _values)
    val[1]
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 15)
  def _reduce_7(val, _values)
    val[1]
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 16)
  def _reduce_8(val, _values)
    val[1]
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 17)
  def _reduce_9(val, _values)
    val[1]
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 18)
  def _reduce_10(val, _values)
    val[1]
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 19)
  def _reduce_11(val, _values)
    val[1]
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 20)
  def _reduce_12(val, _values)
    val[1]
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 24)
  def _reduce_13(val, _values)
                        unless val[0].empty? then
                      val[0].last.comments = decode2(@scanner.get_comment_by_id(@comma_list[-1], nil))
                    end
                    val[0]
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 32)
  def _reduce_14(val, _values)
                        val[0] ? [val[0]] : []
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 36)
  def _reduce_15(val, _values)
                        @comma_list << val[1].object_id
                    val[0].last.comments = decode2(@scanner.get_comment_by_id(@comma_list[-2], @comma_list[-1])) if val[0].last.kind_of? Mailbox
                    val[0] << val[2] if val[2]
                    val[0]
                  
  end
.,.,

# reduce 16 omitted

# reduce 17 omitted

module_eval(<<'.,.,', 'parser.y', 47)
  def _reduce_18(val, _values)
                        if not val[0].empty? and val[0].last.kind_of? Mailbox then
                      val[0].last.comments = decode2(@scanner.get_comment_by_id(@comma_list[-1], nil))
                    end
                    val[0]
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 55)
  def _reduce_19(val, _values)
                        val[0] ? [val[0]] : []
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 59)
  def _reduce_20(val, _values)
                        @comma_list << val[1].object_id
                    if val[0].last.kind_of? Mailbox then
                      val[0].last.comments = decode2(@scanner.get_comment_by_id(@comma_list[-2], @comma_list[-1]))
                    end
                    val[0] << val[2] if val[2]
                    val[0]
                  
  end
.,.,

# reduce 21 omitted

# reduce 22 omitted

# reduce 23 omitted

# reduce 24 omitted

# reduce 25 omitted

module_eval(<<'.,.,', 'parser.y', 76)
  def _reduce_26(val, _values)
                        Mailbox.new(val[0])
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 81)
  def _reduce_27(val, _values)
                        Mailbox.new(val[0])
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 85)
  def _reduce_28(val, _values)
                        Mailbox.new(val[1], val[0])
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 90)
  def _reduce_29(val, _values)
                        [val[0]]
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 94)
  def _reduce_30(val, _values)
                        val[0] << val[1]
                    val[0]
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 100)
  def _reduce_31(val, _values)
                        val[1]
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 104)
  def _reduce_32(val, _values)
                        val[2]
                  
  end
.,.,

# reduce 33 omitted

# reduce 34 omitted

# reduce 35 omitted

# reduce 36 omitted

# reduce 37 omitted

module_eval(<<'.,.,', 'parser.y', 118)
  def _reduce_38(val, _values)
                        Group.new(val[2], val[0])
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 123)
  def _reduce_39(val, _values)
                        decode(val[0])
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 128)
  def _reduce_40(val, _values)
                        [val[0]].compact
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 132)
  def _reduce_41(val, _values)
                        val[0] << val[2] if val[2]
                    val[0]
                  
  end
.,.,

# reduce 42 omitted

module_eval(<<'.,.,', 'parser.y', 139)
  def _reduce_43(val, _values)
                        decode(val[0])
                  
  end
.,.,

# reduce 44 omitted

# reduce 45 omitted

module_eval(<<'.,.,', 'parser.y', 147)
  def _reduce_46(val, _values)
                        val[0].to_s
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 151)
  def _reduce_47(val, _values)
                        val[0] << " #{val[1]}"
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 156)
  def _reduce_48(val, _values)
                        AddrSpec.new(val[0], val[2])
                  
  end
.,.,

# reduce 49 omitted

module_eval(<<'.,.,', 'parser.y', 162)
  def _reduce_50(val, _values)
                        val.join
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 166)
  def _reduce_51(val, _values)
                        val.join
                  
  end
.,.,

# reduce 52 omitted

module_eval(<<'.,.,', 'parser.y', 172)
  def _reduce_53(val, _values)
                        val.join
                  
  end
.,.,

# reduce 54 omitted

# reduce 55 omitted

# reduce 56 omitted

# reduce 57 omitted

# reduce 58 omitted

# reduce 59 omitted

# reduce 60 omitted

module_eval(<<'.,.,', 'parser.y', 187)
  def _reduce_61(val, _values)
                        val.join
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 191)
  def _reduce_62(val, _values)
                        val[0] << val[1]+val[2]
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 195)
  def _reduce_63(val, _values)
                        val[0] << val[1]+val[2]
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 200)
  def _reduce_64(val, _values)
                        val.join
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 204)
  def _reduce_65(val, _values)
                        val.join
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 209)
  def _reduce_66(val, _values)
                        val.join
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 213)
  def _reduce_67(val, _values)
                        val.join
                  
  end
.,.,

# reduce 68 omitted

# reduce 69 omitted

module_eval(<<'.,.,', 'parser.y', 221)
  def _reduce_70(val, _values)
                        MsgIdList.new(val[0])
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 225)
  def _reduce_71(val, _values)
                        val[0] << val[1]
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 230)
  def _reduce_72(val, _values)
                        MsgId.new(val[1,3].join)
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 235)
  def _reduce_73(val, _values)
                        MsgIdList.new()
                  
  end
.,.,

# reduce 74 omitted

module_eval(<<'.,.,', 'parser.y', 240)
  def _reduce_75(val, _values)
                        val[0] << val[1]
                  
  end
.,.,

# reduce 76 omitted

# reduce 77 omitted

module_eval(<<'.,.,', 'parser.y', 253)
  def _reduce_78(val, _values)
                        nil
                  
  end
.,.,

# reduce 79 omitted

module_eval(<<'.,.,', 'parser.y', 260)
  def _reduce_80(val, _values)
                        Received.new(val[0], val[2])
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 265)
  def _reduce_81(val, _values)
                        {}
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 269)
  def _reduce_82(val, _values)
                        val[0][val[1][0]] = val[1][1]
                    val[0]
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 275)
  def _reduce_83(val, _values)
                        unless val[0] =~ /\A[a-zA-Z0-9](-?[a-zA-Z0-9])*\z/ then
                      raise MailParser::ParseError, val[0]+@scanner.rest
                    end
                    [val[0].downcase, val[1].to_s]
                  
  end
.,.,

# reduce 84 omitted

# reduce 85 omitted

# reduce 86 omitted

module_eval(<<'.,.,', 'parser.y', 289)
  def _reduce_87(val, _values)
                        year, month, day, time, zone = val.values_at(3,2,1,4,5)
                    raise MailParser::ParseError, "invalid year: #{year}" unless year =~ /\A\d\d\d\d\Z/
                    m = [nil,"jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"].index month.downcase
                    raise MailParser::ParseError, "invaild month: #{month}" unless m
                    raise MailParser::ParseError, "invalid day of the month: #{day}" unless day =~ /\A\d?\d\Z/
                    begin
                      DateTime.new(year.to_i, m.to_i, day.to_i, time[0], time[1], time[2], zone)
                    rescue ArgumentError
                      raise MailParser::ParseError, "invalid date format"
                    end
                  
  end
.,.,

# reduce 88 omitted

module_eval(<<'.,.,', 'parser.y', 304)
  def _reduce_89(val, _values)
                        unless ['mon','tue','wed','thu','fri','sat','sun'].include? val[0].downcase then
                      raise MailParser::ParseError, "invalid day of the week: #{val[0]}"
                    end
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 311)
  def _reduce_90(val, _values)
                        if val[0] !~ /\A\d\d\Z/ or val[0].to_i > 23 then
                      raise MailParser::ParseError, "invalid hour: #{val[0]}"
                    end
                    if val[2] !~ /\A\d\d\Z/ or val[2].to_i > 59 then
                      raise MailParser::ParseError, "invalid minute: #{val[2]}"
                    end
                    [val[0].to_i, val[2].to_i, 0]
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 321)
  def _reduce_91(val, _values)
                        if val[0] !~ /\A\d\d\Z/ or val[0].to_i > 23 then
                      raise MailParser::ParseError, "invalid hour: #{val[0]}"
                    end
                    if val[2] !~ /\A\d\d\Z/ or val[2].to_i > 59 then
                      raise MailParser::ParseError, "invalid minute: #{val[2]}"
                    end
                    if val[4] !~ /\A\d\d\Z/ or val[4].to_i > 60 then
                      raise MailParser::ParseError, "invalid second: #{val[4]}"
                    end
                    [val[0].to_i, val[2].to_i, val[4].to_i]
                  
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 335)
  def _reduce_92(val, _values)
                        if val[0] =~ /\A[+-]\d\d\d\d\Z/ then
                      val[0]
                    else
                      ZONE[val[0].upcase] || "-0000"
                    end
                  
  end
.,.,

def _reduce_none(val, _values)
  val[0]
end

    end   # class Parser
    end   # module RFC2822
  end   # module MailParser
