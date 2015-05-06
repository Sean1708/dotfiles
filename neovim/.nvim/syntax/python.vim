if exists('b:current_syntax')
  finish
else
  let b:current_syntax = 'python'
endif

syntax keyword pythonStatement break continue del
syntax keyword pythonStatement exec return
syntax keyword pythonStatement pass raise
syntax keyword pythonStatement global nonlocal assert
syntax keyword pythonStatement yield
syntax keyword pythonLambdaExpr lambda
syntax keyword pythonStatement with as

syntax keyword pythonStatement def nextgroup=pythonFunction skipwhite
syntax match pythonFunction "\%(\%(def\s\|@\)\s*\)\@<=\h\%(\w\|\.\)*" contained nextgroup=pythonVars
syntax region pythonVars start="(" skip=+\(".*"\|'.*'\)+ end=")" contained contains=pythonParameters transparent keepend
syntax match pythonParameters "[^,]*" contained contains=pythonParam skipwhite
syntax match pythonParam "[^,]*" contained contains=pythonExtraOperator,pythonLambdaExpr,pythonBuiltinObj,pythonBuiltinType,pythonConstant,pythonString,pythonNumber,pythonBrackets,pythonSelf skipwhite
syntax match pythonBrackets "{[(|)]}" contained skipwhite

syntax keyword pythonStatement class nextgroup=pythonClass skipwhite
syntax match pythonClass "\%(\%(class\s\)\s*\)\@<=\h\%(\w\|\.\)*" contained nextgroup=pythonClassVars
syntax region pythonClassVars start="(" end=")" contained contains=pythonClassParameters transparent keepend
syntax match pythonClassParameters "[^,\*]*" contained contains=pythonBuiltin,pythonBuiltinObj,pythonBuiltinType,pythonExtraOperatorpythonStatement,pythonBrackets,pythonString skipwhite

syntax keyword pythonRepeat        for while
syntax keyword pythonConditional   if elif else
syntax keyword pythonInclude       import from
syntax keyword pythonException     try except finally
syntax keyword pythonOperator      and in is not or

syntax match pythonExtraOperator "\%([~!^&|/%+-]\|\%(class\s*\)\@<!<<\|<=>\|<=\|\%(<\|\<class\s\+\u\w*\s*\)\@<!<[^<]\@=\|===\|==\|=\~\|>>\|>=\|=\@<!>\|\.\.\.\|\.\.\|::\)"
syntax match pythonExtraPseudoOperator "\%(-=\|/=\|\*\*=\|\*=\|&&=\|&=\|&&\|||=\||=\|||\|%=\|+=\|!\~\|!=\)"

syntax match pythonExtraOperator "\%(=\)"
syntax match pythonExtraOperator "\%(\*\|\*\*\)"
syntax keyword pythonSelf self cls

syntax match   pythonDecorator "@" display nextgroup=pythonDottedName skipwhite
syntax match   pythonDottedName "[a-zA-Z_][a-zA-Z0-9_]*\(\.[a-zA-Z_][a-zA-Z0-9_]*\)*" display contained
syntax match   pythonDot        "\." display containedin=pythonDottedName

syntax match   pythonComment   "#.*$" display contains=pythonTodo,@Spell
syntax match   pythonRun       "\%^#!.*$"
syntax match   pythonCoding    "\%^.*\(\n.*\)\?#.*coding[:=]\s*[0-9A-Za-z-_.]\+.*$"
syntax keyword pythonTodo      TODO FIXME XXX contained

syntax match pythonError       "\<\d\+\D\+\>" display
syntax match pythonError       "[$?]" display
syntax match pythonError       "[&|]\{2,}" display
syntax match pythonError       "[=]\{3,}" display

syntax region pythonString     start=+[bB]\='+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonEscape,pythonEscapeError,@Spell
syntax region pythonString     start=+[bB]\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonEscape,pythonEscapeError,@Spell
syntax region pythonString     start=+[bB]\="""+ end=+"""+ keepend contains=pythonEscape,pythonEscapeError,pythonDocTest2,pythonSpaceError,@Spell
syntax region pythonString     start=+[bB]\='''+ end=+'''+ keepend contains=pythonEscape,pythonEscapeError,pythonDocTest,pythonSpaceError,@Spell

syntax match  pythonEscape     +\\[abfnrtv'"\\]+ display contained
syntax match  pythonEscape     "\\\o\o\=\o\=" display contained
syntax match  pythonEscapeError    "\\\o\{,2}[89]" display contained
syntax match  pythonEscape     "\\x\x\{2}" display contained
syntax match  pythonEscapeError    "\\x\x\=\X" display contained
syntax match  pythonEscape     "\\$"

syntax region pythonUniString  start=+[uU]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError,@Spell
syntax region pythonUniString  start=+[uU]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError,@Spell
syntax region pythonUniString  start=+[uU]"""+ end=+"""+ keepend contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
syntax region pythonUniString  start=+[uU]'''+ end=+'''+ keepend contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell

syntax match  pythonUniEscape          "\\u\x\{4}" display contained
syntax match  pythonUniEscapeError     "\\u\x\{,3}\X" display contained
syntax match  pythonUniEscape          "\\U\x\{8}" display contained
syntax match  pythonUniEscapeError     "\\U\x\{,7}\X" display contained
syntax match  pythonUniEscape          "\\N{[A-Z ]\+}" display contained
syntax match  pythonUniEscapeError "\\N{[^A-Z ]\+}" display contained

syntax region pythonRawString  start=+[rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,@Spell
syntax region pythonRawString  start=+[rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,@Spell
syntax region pythonRawString  start=+[rR]"""+ end=+"""+ keepend contains=pythonDocTest2,pythonSpaceError,@Spell
syntax region pythonRawString  start=+[rR]'''+ end=+'''+ keepend contains=pythonDocTest,pythonSpaceError,@Spell

syntax match pythonRawEscape           +\\['"]+ display transparent contained

syntax region pythonUniRawString   start=+[uU][rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError,@Spell
syntax region pythonUniRawString   start=+[uU][rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError,@Spell
syntax region pythonUniRawString   start=+[uU][rR]"""+ end=+"""+ keepend contains=pythonUniRawEscape,pythonUniRawEscapeError,pythonDocTest2,pythonSpaceError,@Spell
syntax region pythonUniRawString   start=+[uU][rR]'''+ end=+'''+ keepend contains=pythonUniRawEscape,pythonUniRawEscapeError,pythonDocTest,pythonSpaceError,@Spell

syntax match  pythonUniRawEscape   "\([^\\]\(\\\\\)*\)\@<=\\u\x\{4}" display contained
syntax match  pythonUniRawEscapeError  "\([^\\]\(\\\\\)*\)\@<=\\u\x\{,3}\X" display contained

syntax match pythonStrFormat "{{\|}}" contained containedin=pythonString,pythonUniString,pythonRawString,pythonUniRawString
syntax match pythonStrFormat "{\([a-zA-Z0-9_]*\|\d\+\)\(\.[a-zA-Z_][a-zA-Z0-9_]*\|\[\(\d\+\|[^!:\}]\+\)\]\)*\(![rs]\)\=\(:\({\([a-zA-Z_][a-zA-Z0-9_]*\|\d\+\)}\|\([^}]\=[<>=^]\)\=[ +-]\=#\=0\=\d*\(\.\d\+\)\=[bcdeEfFgGnoxX%]\=\)\=\)\=}" contained containedin=pythonString,pythonUniString,pythonRawString,pythonUniRawString

syntax region pythonDocstring  start=+^\s*[uU]\?[rR]\?"""+ end=+"""+ keepend excludenl contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError
syntax region pythonDocstring  start=+^\s*[uU]\?[rR]\?'''+ end=+'''+ keepend excludenl contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError

syntax match   pythonHexError  "\<0[xX]\x*[g-zG-Z]\x*[lL]\=\>" display
syntax match   pythonHexNumber "\<0[xX]\x\+[lL]\=\>" display
syntax match   pythonOctNumber "\<0[oO]\o\+[lL]\=\>" display
syntax match   pythonBinNumber "\<0[bB][01]\+[lL]\=\>" display
syntax match   pythonNumber    "\<\d\+[lLjJ]\=\>" display
syntax match   pythonFloat "\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>" display
syntax match   pythonFloat "\<\d\+[eE][+-]\=\d\+[jJ]\=\>" display
syntax match   pythonFloat "\<\d\+\.\d*\([eE][+-]\=\d\+\)\=[jJ]\=" display
syntax match   pythonOctError  "\<0[oO]\=\o*[8-9]\d*[lL]\=\>" display
syntax match   pythonBinError  "\<0[bB][01]*[2-9]\d*[lL]\=\>" display

syntax keyword pythonBuiltinObj True False Ellipsis None NotImplemented
syntax keyword pythonBuiltinObj __debug__ __doc__ __file__ __name__ __package__
syntax keyword pythonBuiltinType type object
syntax keyword pythonBuiltinType str basestring unicode buffer bytearray bytes chr unichr
syntax keyword pythonBuiltinType dict int long bool float complex set frozenset list tuple
syntax keyword pythonBuiltinType file super

syntax keyword pythonBuiltinFunc   __import__ abs all any apply
syntax keyword pythonBuiltinFunc   bin callable classmethod cmp coerce compile
syntax keyword pythonBuiltinFunc   delattr dir divmod enumerate eval execfile filter
syntax keyword pythonBuiltinFunc   format getattr globals locals hasattr hash help hex id
syntax keyword pythonBuiltinFunc   input intern isinstance issubclass iter len map max min
syntax keyword pythonBuiltinFunc   next oct open ord pow property range xrange
syntax keyword pythonBuiltinFunc   raw_input reduce reload repr reversed round setattr
syntax keyword pythonBuiltinFunc   slice sorted staticmethod sum vars zip
syntax keyword pythonBuiltinFunc   print

syntax keyword pythonExClass   BaseException
syntax keyword pythonExClass   Exception StandardError ArithmeticError
syntax keyword pythonExClass   LookupError EnvironmentError
syntax keyword pythonExClass   AssertionError AttributeError BufferError EOFError
syntax keyword pythonExClass   FloatingPointError GeneratorExit IOError
syntax keyword pythonExClass   ImportError IndexError KeyError
syntax keyword pythonExClass   KeyboardInterrupt MemoryError NameError
syntax keyword pythonExClass   NotImplementedError OSError OverflowError
syntax keyword pythonExClass   ReferenceError RuntimeError StopIteration
syntax keyword pythonExClass   SyntaxError IndentationError TabError
syntax keyword pythonExClass   SystemError SystemExit TypeError
syntax keyword pythonExClass   UnboundLocalError UnicodeError
syntax keyword pythonExClass   UnicodeEncodeError UnicodeDecodeError
syntax keyword pythonExClass   UnicodeTranslateError ValueError VMSError
syntax keyword pythonExClass   WindowsError ZeroDivisionError
syntax keyword pythonExClass   Warning UserWarning BytesWarning DeprecationWarning
syntax keyword pythonExClass   PendingDepricationWarning SyntaxWarning
syntax keyword pythonExClass   RuntimeWarning FutureWarning
syntax keyword pythonExClass   ImportWarning UnicodeWarning

syntax sync minlines=2000

highlight default link  pythonStatement    Statement
highlight default link  pythonLambdaExpr   Statement
highlight default link  pythonInclude      Include
highlight default link  pythonFunction     Function
highlight default link  pythonClass        Type
highlight default link  pythonParameters   Normal
highlight default link  pythonParam        Normal
highlight default link  pythonBrackets     Normal
highlight default link  pythonClassParameters Normal
highlight default link  pythonSelf         Identifier

highlight default link  pythonConditional  Conditional
highlight default link  pythonRepeat       Repeat
highlight default link  pythonException    Exception
highlight default link  pythonOperator     Operator
highlight default link  pythonExtraOperator        Operator
highlight default link  pythonExtraPseudoOperator  Operator

highlight default link  pythonDecorator    Define
highlight default link  pythonDottedName   Function
highlight default link  pythonDot          Normal

highlight default link  pythonComment      Comment
highlight default link  pythonCoding       Special
highlight default link  pythonRun          Special
highlight default link  pythonTodo         Todo

highlight default link  pythonError        Error
highlight default link  pythonIndentError  Error
highlight default link  pythonSpaceError   Error

highlight default link  pythonString       String
highlight default link  pythonDocstring    String
highlight default link  pythonUniString    String
highlight default link  pythonRawString    String
highlight default link  pythonUniRawString String

highlight default link  pythonEscape       Special
highlight default link  pythonEscapeError  Error
highlight default link  pythonUniEscape    Special
highlight default link  pythonUniEscapeError Error
highlight default link  pythonUniRawEscape Special
highlight default link  pythonUniRawEscapeError Error

highlight default link  pythonStrFormatting Special
highlight default link  pythonStrFormat    Special
highlight default link  pythonStrTemplate  Special

highlight default link  pythonDocTest      Special
highlight default link  pythonDocTest2     Special

highlight default link  pythonNumber       Number
highlight default link  pythonHexNumber    Number
highlight default link  pythonOctNumber    Number
highlight default link  pythonBinNumber    Number
highlight default link  pythonFloat        Float
highlight default link  pythonOctError     Error
highlight default link  pythonHexError     Error
highlight default link  pythonBinError     Error

highlight default link  pythonBuiltinType  Type
highlight default link  pythonBuiltinObj   Structure
highlight default link  pythonBuiltinFunc  Function

highlight default link  pythonExClass      Structure
