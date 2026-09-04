lua
===

.. symbol:: lua-api

Overview
--------

For Loops Overview
~~~~~~~~~~~~~~~~~~

You can use **for loops** in Lua to iterate over arrays and tables, performing tasks for each element.

This example simply iterates i over the values 1 to 10

.. code-block:: lua

   -- Iterate from 1 to 10
   for i = 1, 10 do
     print( i )
   end
   

This example uses the `ipairs` function to sequentially iterate over a table. Note that ipairs only works on tables that have sequential elements beginning at 1.

.. code-block:: lua

   -- Iterate over an array named 'arr'
   arr = { 3, 2, 1 }
   
   for i,v in ipairs(arr) do
     print( "arr["..i.."] = "..v )
   end
   
   -- Prints:
   --  arr[1] = 3
   --  arr[2] = 2
   --  arr[3] = 1
   

This example uses `pairs` to iterate over all the key/value pairs in a table, unlike `ipairs` the keys do not have to be integral values, and can be anything.

.. code-block:: lua

   -- Iterate over a table named 'tab'
   tab = { x = 3, y = "string", z = 1 }
   
   for key,value in pairs(tab) do
     print( "tab."..key.." = "..value )
   end
   
   -- Prints:
   --  tab.y = string
   --  tab.x = 3
   --  tab.z = 1

Conditionals Overview
~~~~~~~~~~~~~~~~~~~~~

Use **conditionals** to test for a particular circumstance and then branch your code appropriately. See the examples below.

.. code-block:: lua

   -- Check if x is equal to 10
   if x == 10 then
     print( "x equals 10" )
   end
   
   -- else and elseif
   if x == 10 then
     print( "x is 10" )
   elseif x == 5 then
     print( "x is 5" )
   else
     print( "x is something else: "..x )
   end
   
   -- Checking multiple values
   if x == 10 and y < 5 then
     print( "x is 10 and y is less than 5" )
   elseif x == 5 or y == 3 then
     print( "x is 5 or y is 3" )
   else
     print( "x is "..x.." and y is "..y )
   end

While Loops Overview
~~~~~~~~~~~~~~~~~~~~

Use while and repeat loops to repeat code until a condition is true. While loops are used when you can't predict the number of times a loop will iterate, such as when reading input from a file or testing for a key press.

.. code-block:: lua

   -- simple while loop. The condition is evaluated at the beginning of the loop. The loop will never get executed if the condition is false at the beginning of the loop.
   while i<=5 do
     print(i)
     i=i+1
   end
   
   -- repeat loop. The condition is evaluated at the end of the loop, so the code always gets executed at least once
   repeat
     print(i)
     i=i+1
   until i>5
   
   -- break statement: break exits a loop and continues program flow with the statement immediately following the end or until condition
   while true do
     print(i)
     i=i+1
     if i>5 then
         break
     end
   end

Annotations Overview
~~~~~~~~~~~~~~~~~~~~

Annotations can be used to indicate the type of a variable to Codea, giving you better auto-completion support.

To write a code annotation, start a comment with three dashes (`---`). Codea will look at the next line of code to try and auto-complete your comment if it is an assignement or function definition. You can also manually write annotations anywhere in your code following the format `--- variableName: variableType`.

When using annotations for Objective-C types, this will add Objective-C properties and methods auto-completion to your variables.

.. code-block:: lua

   -- method annotation
   --- makeBox Creates a box body
   --- pos: vec2, bottom-left position of the box
   --- size: vec2, size of the box
   function createBoxBody(pos, size)
   
   -- variable annotation
   --- textView: objc.UITextView
   textView = objc.UITextView()

Language
--------

.. lua:function:: print( ... )

   Prints values to the output console.

   :param ...: values to print
   :syntax:

      .. code-block:: lua

         print( ... )

.. lua:function:: warn( msg, ... )

   Emits a warning to the output console, composed by concatenating all its arguments
   (which must be strings). Warnings appear alongside ``print`` output, marked as
   warnings.

   .. helptext:: emit a warning to the output console

   A one-piece message starting with ``@`` is a *control message*: it changes how the
   warning system behaves instead of being displayed. Codea recognizes four:

   .. list-table::
      :header-rows: 1
      :widths: 22 78

      * - Control message
        - Effect
      * - ``"@off"``
        - Stop emitting warnings.
      * - ``"@on"``
        - Resume emitting warnings.
      * - ``"@once"``
        - Emit each distinct message only the first time it occurs. This is the default.
      * - ``"@always"``
        - Emit every warning, including repeats.

   Codea differs from standard Lua in two ways, both chosen so that warnings behave the
   way they always have in Codea:

   - Warnings are **on** by default, so there is no need to call ``warn( "@on" )``
     before your first warning.
   - Repeated messages are suppressed by default, as if ``warn( "@once" )`` were already
     in effect. This keeps a warning inside ``draw()`` from flooding the console. Use
     ``warn( "@always" )`` when you want every occurrence.

   Unknown control messages are ignored. A control message must be a single argument, so
   ``warn( "@of", "f" )`` emits a warning reading ``@off`` rather than turning warnings
   off.

   :param msg: the warning message, or one of the control messages above
   :param ...: additional strings, concatenated onto ``msg``
   :syntax:

      .. code-block:: lua

         warn( "player health is negative" )

         -- Repeats are suppressed by default, so this shows a single warning
         for i = 1, 100 do
             warn( "this appears only once" )
         end

         -- Opt in to seeing every occurrence
         warn( "@always" )
         warn( "@once" )

         warn( "@off" )
         warn( "this is not shown" )
         warn( "@on" )

         -- Arguments are concatenated, so this emits one warning reading "x = 42"
         warn( "x = ", tostring( 42 ) )

.. lua:function:: ipairs( table )

   `ipairs` can be used to iterate over a table sequentially, starting from the index 1 and continuing until the first integer key absent from the table. Returns three values: an iterator function, the table, and 0.

   :param table: table to iterate over
   :return: Returns three values: an iterator function, the table, and 0
   :rtype: table
   :syntax:

      .. code-block:: lua

         for i,v in ipairs( t ) do body end
         
         -- This will iterate over the pairs:
         --   (1,t[1]), (2,t[2]), ...

.. lua:function:: pairs( table )

   `pairs` can be used to iterate over a tables key-value pairs. Returns three values: the next function, the table t, and nil.

   :param table: table to iterate over
   :return: Returns three values: the next function, the table t, and nil
   :rtype: table
   :syntax:

      .. code-block:: lua

         for k,v in pairs( t ) do body end
         
         -- This will iterate over all key-value
         -- pairs in table t

Tables
------

.. lua:function:: table.concat( table, sep )

   Given an array where all elements are strings or numbers, returns `table[i]..sep..table[i+1] ... sep..table[j]`. The default value for `sep` is the empty string, the default for `i` is 1, and the default for `j` is the length of the table. If `i` is greater than `j`, returns the empty string.

   :param table: table to concatenate
   :param sep: separator string
   :param i: int, starting index to concatenate from
   :param j: int, ending index
   :return: A string of the elements in `table` concatenated with each other, separated by `sep`
   :rtype: string
   :syntax:

      .. code-block:: lua

         table.concat( table )
         table.concat( table, sep )
         table.concat( table, sep, i )
         table.concat( table, sep, i, j )

.. lua:function:: table.move( a1, f, e, t, a2 )

   Moves elements from table `a1` into table `a2`. This function performs the equivalent to the multiple assignment: a2[t], ... = a1[f], ..., a1[e]. The default value for `a2` is `a1`. The destination range can overlap with the source range. Index `f` must be positive.

   :param a1: table to move elements from
   :param f: starting index in table to move from
   :type f: integer
   :param e: ending index in table to move from
   :type e: integer
   :param t: starting index in table to move into
   :type t: integer
   :param a2: table to move elements into (defaults to `a1`)
   :syntax:

      .. code-block:: lua

         table.move( a1, f, e, t )
         table.move( a1, f, e, t, a2 )

.. lua:function:: table.insert( table, pos, value )

   Inserts element `value` at position `pos` in `table`, shifting up other elements to open space, if necessary. The default value for `pos` is n+1, where n is the length of the table, so that a call `table.insert(t,x)` inserts x at the end of table t.

   :param table: table to insert into
   :param pos: int, position to inset
   :param value: value to insert
   :syntax:

      .. code-block:: lua

         table.insert( table, value )
         table.insert( table, pos, value )

.. lua:function:: table.remove( table, pos )

   Removes from `table` the element at position `pos`, shifting down other elements to close the space, if necessary. Returns the value of the removed element. The default value for `pos` is n, where n is the length of the table, so that a call `table.remove(t)` removes the last element of table t.

   :param table: table to insert into
   :param pos: int, position of value to remove
   :return: Value of the removed element
   :syntax:

      .. code-block:: lua

         table.remove( table )
         table.remove( table, pos )

.. lua:function:: table.pack(...)

   Returns a new table with all parameters stored into keys 1, 2, etc. and with a field "n" with the total number of parameters. Note that the resulting table may not be a sequence.

   :param ...: arguments to pack into table
   :return: table with all parameters packed
   :rtype: table
   :syntax:

      .. code-block:: lua

         table.pack( ... )

.. lua:function:: table.unpack(list)

   Returns the elements from the given list.

   :param list: list to unpack
   :return: elements unpacked from list
   :syntax:

      .. code-block:: lua

         table.unpack( list )

.. lua:function:: table.sort( table )

   Sorts table elements in a given order, in-place, from `table[1]` to `table[n]`, where n is the length of the table. If `comp` is given, then it must be a function that receives two table elements and returns true when the first is less than the second (so that `not comp(a[i+1],a[i]`) will be true after the sort). If `comp` is not given, then the standard Lua operator < is used instead.

   The sort algorithm is not stable; that is, elements considered equal by the given order may have their relative positions changed by the sort.

   :param table: the table to sort
   :param comp: a function that receives two table elements and returns true when the first is less than the second
   :syntax:

      .. code-block:: lua

         table.sort( table )
         table.sort( table, comp )

Strings
-------

.. lua:function:: string.byte( s, i, j )

   Returns the internal numerical codes of the characters s[i], s[i+1], ..., s[j]. The default value for `i` is 1; the default value for `j` is `i`. These indices are corrected following the same rules of `string.sub`.

   :param s: string to use
   :param i: first index, defaults to 1
   :param j: last index, defaults to `i`
   :return: The internal numerical codes for characters s[i] up to s[j]
   :syntax:

      .. code-block:: lua

         string.byte( s )
         string.byte( s, i )
         string.byte( s, i, j )

.. lua:function:: string.char( ... )

   Returns a string with length equal to the number of arguments, in which each character has the internal numerical code equal to its corresponding argument.

   :param ...: a variable number of numerical codes
   :return: String composed of characters equal to the numerical codes used as arguments
   :rtype: string
   :syntax:

      .. code-block:: lua

         string.char( ... )

.. lua:function:: string.dump( function )

   Returns a string containing a binary representation (a *binary chunk*) of the given function, so that a later `load` on this string returns a copy of the function (with new upvalues). If `strip` is a true value, the binary representation is created without debug information about the function (local variable names, lines, etc).

   :param function: a function to convert to binary string
   :param strip: whether to strip debug information
   :type strip: boolean
   :return: Binary string representation of the specified function
   :rtype: string
   :syntax:

      .. code-block:: lua

         string.dump( function )
         string.dump( function, strip )

.. lua:function:: string.find( s, pattern )

   Looks for the first match of `pattern` in the string `s`. If it finds a match, then `string.find()` returns the indices of `s` where the occurrence starts and ends; otherwise, it returns `nil`. A third, optional numerical argument `init` specifies where to start the search, its default value is 1 and can be negative. A value of `true` as the fourth optional argument `plain` turns off the pattern matching facilities so the function performs a plain "find substring" operation, with no characters in `pattern` being considered "magic." Note that if `plain` is given, then `init` must be given as well.

   If the pattern has captures, then in a successful match the captured values are also returned, after the two indices.

   :param s: string to search in
   :param pattern: pattern to look for
   :param init: starting character in string to search from, default is 1
   :param plain: perform a plain substring search
   :type plain: boolean
   :return: The start and end indices of the match, or `nil` if no match. If the pattern has captures then captured values are also returned after the indices
   :syntax:

      .. code-block:: lua

         string.find( s, pattern )
         string.find( s, pattern, init )
         string.find( s, pattern, init, plain )

.. lua:function:: string.format( formatstring, ... )

   Returns a formatted version of its variable arguments following the description given in the first argument, which must be a string. The format string follows the same rules as the `printf` family of standard C functions. The only difference are that the options/modifiers `*, 1, L, n, p` and `h` are not supported and that there is an extra option `q`. The `q` option formats a string in a form suitable to be safely read back by the Lua interpreter, for example all double quotes, newlines, embedded zeros and backslashes will be escaped when written.

   :param formatstring: string defining the format
   :return: A formatted string
   :rtype: string
   :syntax:

      .. code-block:: lua

         string.format( formatstring, ... )

.. lua:function:: string.len( s )

   Receives a string and returns its length. The empty string "" has length 0.

   :param s: get the length of this string
   :return: Length of string `s`
   :rtype: string
   :syntax:

      .. code-block:: lua

         string.len( s )

.. lua:function:: string.gmatch( s, pattern )

   Returns an iterator function that, each time it is called, returns the next captures from pattern (see **Patterns Overview**) over the string s. If pattern specifies no captures, then the whole match is produced in each call.

   :param s: string to search
   :param pattern: pattern to match
   :return: Iterator function over matches of `pattern` within the string
   :rtype: string
   :syntax:

      .. code-block:: lua

         string.gmatch( s, pattern )

.. lua:function:: string.gsub( s, pattern, repl )

   Returns a copy of `s` in which all (or the first `n`, if given) occurrences of the `pattern` (see **Patterns Overview**) have been replaced by a replacement string specified by `repl`, which can be a string, a table, or a function. gsub also returns, as its second value, the total number of matches that occurred. The name gsub comes from *Global SUBstitution*.

   If `repl` is a string, then its value is used for replacement. The character `%` works as an escape character: any sequence in `repl` of the form `%d`, with `d` between 1 and 9, stands for the value of the `d`-th captured substring. The sequence `%0` stands for the whole match. The sequence `%%` stands for a single `%`.

   If `repl` is a table, then the table is queried for every match, using the first capture as the key.

   If `repl` is a function, then this function is called every time a match occurs, with all captured substrings passed as arguments, in order.

   In any case, if the pattern specifies no captures, then it behaves as if the whole pattern was inside a capture.

   If the value returned by the table query or by the function call is a string or a number, then it is used as the replacement string; otherwise, if it is false or nil, then there is no replacement (that is, the original match is kept in the string).

   :param s: string to substitute
   :param pattern: pattern to match
   :param repl: table or function, replacement parameter
   :type repl: string
   :param n: number of occurrences to match (all if not specified)
   :type n: integer
   :return: Returns a copy of `s` with substitutions made, as well as the number of matches
   :rtype: number
   :syntax:

      .. code-block:: lua

         string.gsub( s, pattern, repl )
         string.gsub( s, pattern, repl, n )

.. lua:function:: string.lower( s )

   Receives a string and returns a copy of this string with all uppercase letters changed to lowercase. All other characters are left unchanged.

   :param s: get a lowercase version of this string
   :return: Lowercase version of string `s`
   :rtype: string
   :syntax:

      .. code-block:: lua

         string.lower( s )

.. lua:function:: string.upper( s )

   Receives a string and returns a copy of this string with all lowercase letters changed to uppercase. All other characters are left unchanged.

   :param s: get an uppercase version of this string
   :return: Uppercase version of string `s`
   :rtype: string
   :syntax:

      .. code-block:: lua

         string.upper( s )

.. lua:function:: string.match( s, pattern )

   Looks for the first match of `pattern` in the string `s`. If it finds one then `string.match()` returns the captures from the pattern, otherwise it returns `nil`. If `pattern` specifies no captures, then the whole match is returned. A third optional numerical argument `init` specifies where to start the search. Its default is 1 and can be negative.

   :param s: string to search
   :param pattern: pattern to match
   :param init: starting location in string
   :return: Captures from the first match of `pattern` in string `s`, or `nil` if none were found
   :rtype: string
   :syntax:

      .. code-block:: lua

         string.match( s, pattern )
         string.match( s, pattern, init )

.. lua:function:: string.rep( s, n )

   Returns a string that is the concatenation of `n` copies of the string `s`.

   :param s: string to replicate
   :param n: int, number of times to replicate the string
   :return: `n` concatenations of string `s`
   :rtype: string
   :syntax:

      .. code-block:: lua

         string.rep( s, n )

.. lua:function:: string.reverse( s )

   This function returns the string `s` reversed.

   :param s: string to reverse
   :return: `s` reversed
   :syntax:

      .. code-block:: lua

         string.reverse( s )

.. lua:function:: string.sub( s, i, j )

   Returns the substring of `s` that starts at `i` and continues until `j`; `i` and `j` can be negative. If `j` is absent, then it is assumed to be equal to -1 (which is the same as the string length). In particular, the call `string.sub(s,1,j)` returns a prefix of `s` with length `j`, and string.sub(s, -i) returns a suffix of `s` with length `i`.

   :param s: find substring of this string
   :param i: int, starting index
   :param j: int, ending index
   :return: Substring of string `s`
   :rtype: string
   :syntax:

      .. code-block:: lua

         string.sub( s, i )
         string.sub( s, i, j )

.. lua:function:: string.pack( fmt, v1, v2, ... )

   Returns a binary string containing the values `v1`, `v2`, etc. packed (that is, serialized in binary form) according to the format string `fmt`.

   :param fmt: format string specifying binary format
   :param ...: arguments to pack
   :return: Values packed into binary string
   :rtype: string
   :syntax:

      .. code-block:: lua

         string.pack( fmt, v1, v2, ... )

.. lua:function:: string.packsize( fmt )

   Returns the size of a string resulting from `string.pack` with the given format. The format string cannot have the variable-length options 's' or 'z'

   :param fmt: format string specifying binary format
   :return: Size of string packed with the given format
   :rtype: string
   :syntax:

      .. code-block:: lua

         string.packsize( fmt )

.. lua:function:: string.unpack( fmt, s )

   Returns the values packed in string `s` according to the format string `fmt`. An optional pos marks where to start reading in `s` (default is 1). After the read values, this function also returns the index of the first unread byte in `s`.

   :param fmt: format string specifying binary format
   :param s: string to unpack
   :return: The values packed in `s`
   :syntax:

      .. code-block:: lua

         string.unpack( fmt, s )
         string.unpack( fmt, s, pos )

Patterns Overview
~~~~~~~~~~~~~~~~~

Patterns in Lua are described by regular strings, which are interpreted as patterns by the
pattern-matching functions `string.find`, `string.gmatch`, `string.gsub`, and `string.match`.
This section describes the syntax and the meaning (that is, what they match) of these strings.


**Character Class**


A character class is used to represent a set of characters. The following combinations are
allowed in describing a character class:


.. code-block:: lua

   x: (where x is not one of the magic characters
    ^$()%.[]*+-?) represents the character x
    itself.
   .: (a dot) represents all characters.
   %a: represents all letters.
   %c: represents all control characters.
   %d: represents all digits.
   %g: represents all printable characters except space.
   %l: represents all lowercase letters.
   %p: represents all punctuation characters.
   %s: represents all space characters.
   %u: represents all uppercase letters.
   %w: represents all alphanumeric characters.
   %x: represents all hexadecimal digits.
   %x: (where x is any non-alphanumeric character)
     represents the character x.
     This is the standard way to escape
     the magic characters. Any non-alphanumeric
     character (including all punctuations, even
     the non-magical) can be preceded by a '%'
     when used to represent itself in a pattern.
   [set]: represents the class which is
     the union of all characters in set.
     A range of characters can be specified
     by separating the end characters of the
     range, in ascending order, with a '-'.
     All classes %x described above can
     also be used as components in set.
     All other characters in set represent
     themselves. For example, [%w_] (or [_%w])
     represents all alphanumeric characters
     plus the underscore, [0-7] represents
     the octal digits, and [0-7%l%-] represents
     the octal digits plus the lowercase letters
     plus the '-' character.
   [^set]: represents the complement of set,
     where set is interpreted as above.
   
   

For all classes represented by single letters (%a, %c, etc.), the corresponding uppercase
letter represents the complement of the class. For instance, %S represents all non-space characters.


The definitions of letter, space, and other character groups depend on the current locale.
In particular, the class [a-z] may not be equivalent to %l.


**Pattern Item**


A pattern item can be:


.. code-block:: lua

   - a single character class, which matches
   any single character in the class;
   - a single character class followed by '*',
   which matches zero or more repetitions
   of characters in the class. These
   repetition items will always match
   the longest possible sequence;
   - a single character class followed by '+',
   which matches one or more repetitions of
   characters in the class. These repetition
   items will always match the longest
   possible sequence;
   - a single character class followed by '-',
   which also matches zero or more repetitions
   of characters in the class. Unlike '*',
   these repetition items will always match
   the shortest possible sequence;
   - a single character class followed by '?',
   which matches zero or one occurrence of
   a character in the class. It always
   matches one occurrence if possible;
   - %n, for n between 1 and 9; such item
   matches a substring equal to the n-th
   captured string (see below);
   - %bxy, where x and y are two distinct
   characters; such item matches strings
   that start with x, end with y,
   and where the x and y are balanced.
   This means that, if one reads the string
   from left to right, counting +1 for an x
   and -1 for a y, the ending y is the first
   y where the count reaches 0.
   For instance, the item %b() matches
   expressions with balanced parentheses.
   - %f[set], a frontier pattern; such item
   matches an empty string at any position
   such that the next character belongs to
   set and the previous character does not
   belong to set. The set set is interpreted
   as previously described. The beginning
   and the end of the subject are handled
   as if they were the character '\0'.
   
   

**Pattern**


A pattern is a sequence of pattern items. A caret '^' at the beginning of a pattern anchors the match at the
beginning of the subject string. A '$' at the end of a pattern anchors the match at the end of the subject string.
At other positions, '^' and '$' have no special meaning and represent themselves.


**Captures**


A pattern can contain sub-patterns enclosed in parentheses; they describe captures. When a match succeeds,
the substrings of the subject string that match captures are stored (captured) for future use.
Captures are numbered according to their left parentheses. For instance, in the pattern "(a*(.)%w(%s*))",
the part of the string matching "a*(.)%w(%s*)" is stored as the first capture
(and therefore has number 1); the character matching "." is captured with number 2,
and the part matching "%s*" has number 3.


As a special case, the empty capture () captures the current string position (a number).
For instance, if we apply the pattern "()aa()" on the string "flaaap", there will be two captures: 3 and 5.

Math
----

.. lua:function:: math.abs( value )

   This function returns the absolute value of `value`. For example, `math.abs(-5)` returns 5.

   :param value: int or float, the number to get the absolute value of
   :return: The absolute value of value
   :syntax:

      .. code-block:: lua

         math.abs( value )

.. lua:function:: math.acos( value )

   This function returns the arc cosine of `value` in radians

   :param value: int or float, compute the arc cosine of this number
   :return: The arc cosine of value in radians
   :syntax:

      .. code-block:: lua

         math.acos( value )

.. lua:function:: math.asin( value )

   This function returns the arc sine of `value` in radians

   :param value: int or float, compute the arc sine of this number
   :return: The arc sine of value in radians
   :syntax:

      .. code-block:: lua

         math.asin( value )

.. lua:function:: math.atan( y, x )

   Returns the arc tangent of y/x (in radians), using the signs of both arguments to find the quadrant of the result. It also handles correctly the case of x being zero

   The default value for x is 1, so that the call math.atan(y) returns the arc tangent of y

   :param y: numerator for arc tangent
   :type y: number
   :param x: denominator for arc tangent (defaults to 1)
   :type x: number
   :return: The arc tangent of y/x in radians
   :syntax:

      .. code-block:: lua

         math.atan( y )
         math.atan( y, x )

.. lua:function:: math.ceil( value )

   This function returns the smallest integer larger than or equal to `value`. This rounds a number up to the nearest integer. For example, `math.ceil(5.2)` returns 6.

   :param value: int or float, compute the smallest integer larger than or equal to this number
   :return: The smallest integer larger than or equal to value
   :rtype: integer
   :syntax:

      .. code-block:: lua

         math.ceil( value )

.. lua:function:: math.cos( value )

   This function returns the cosine of `value` (assumed to be in radians).

   :param value: int or float, compute the cosine of this number
   :return: Cosine of value
   :syntax:

      .. code-block:: lua

         math.cos( value )

.. lua:function:: math.cosh( value )

   This function returns hyperbolic cosine of `value`.

   :param value: int or float, compute the hyperbolic cosine of this number
   :return: Hyperbolic cosine of value
   :syntax:

      .. code-block:: lua

         math.cosh( value )

.. lua:function:: math.deg( value )

   This function returns the angle specified by `value` (given in radians) in degrees.

   :param value: int or float, angle in radians to convert to degrees
   :return: Angle specified by value (in radians) in degrees
   :syntax:

      .. code-block:: lua

         math.deg( value )

.. lua:function:: math.rad( value )

   This function returns the angle specified by `value` (given in degrees) in radians.

   :param value: int or float, angle in degrees to convert to radians
   :return: Angle specified by value (in degrees) in radians
   :syntax:

      .. code-block:: lua

         math.rad( value )

.. lua:function:: math.exp( value )

   This function returns **e** raised to `value`

   :param value: int or float, exponent of e
   :return: e raised to the power of value
   :syntax:

      .. code-block:: lua

         math.exp( value )

.. lua:function:: math.floor( value )

   This function returns the largest integer smaller than or equal to `value`. This rounds a number down to the nearest integer. For example, `math.floorTh(5.7)` returns 5.

   :param value: int or float, compute the largest integer smaller than or equal to this number
   :return: The largest integer smaller than or equal to value
   :rtype: integer
   :syntax:

      .. code-block:: lua

         math.floor( value )

.. lua:function:: math.fmod( x, y )

   This function returns the remainder of the division of `x` by `y` that rounds the quotient towards zero.

   :param x: int or float
   :param y: int or float
   :return: The remainder of the division of x by y
   :syntax:

      .. code-block:: lua

         math.fmod( x, y )

.. lua:function:: math.frexp( value )

   This function returns m and e such that `value` = m2^e, e is an integer and the absolute value of m is in the range [0.5, 1) (or zero when x is zero).

   :param value: int or float
   :return: m and e such that value = m2^e, e is an integer and the absolute value of m is in the range [0.5, 1) (or zero when x is zero).
   :rtype: integer
   :syntax:

      .. code-block:: lua

         math.frexp( value )

.. lua:function:: math.ldexp( m, e )

   This function returns m2^e (e should be an integer)

   :param m: int or float
   :param e: int
   :return: m2^e
   :syntax:

      .. code-block:: lua

         math.ldexp( m, e )

.. lua:function:: math.log( value )

   This function returns the natural logarithm of `value`

   :param value: int or float, compute the natural logarithm of this value
   :return: The natural logarithm of value
   :syntax:

      .. code-block:: lua

         math.log( value )

.. lua:function:: math.max( value, ... )

   This function returns maximum value among its arguments.

   :param value: any comparable value
   :return: The maximum value among its arguments
   :syntax:

      .. code-block:: lua

         math.max( value, ... )

.. lua:function:: math.min( value, ... )

   This function returns minimum value among its arguments.

   :param value: any comparable value
   :return: The minimum value among its arguments
   :syntax:

      .. code-block:: lua

         math.min( value, ... )

.. lua:function:: math.modf( value )

   This function returns two numbers, the integral part of `value` and the fractional part of `value`.

   :param value: int or float
   :return: Two numbers, the integral part of value and the fractional part of value
   :syntax:

      .. code-block:: lua

         math.modf( value )

.. lua:function:: math.random()

   When called without arguments, `math.random()` returns a uniform pseudo-random real number in the range [0, 1). When called with an integer number `maximum`, `math.random()` returns a uniform pseudo-random integer in the range [1, maximum]. When called with two integer numbers, `minimum` and `maximum`, `math.random()` returns a uniform pseudo-random integer in the range [minimum, maximum].

   :param minimum: int, minimum value of returned pseudo-random number
   :param maximum: int, maximum value of returned pseudo-random number
   :return: A uniform pseudo-random real number or integer (depending on parameters)
   :rtype: integer
   :syntax:

      .. code-block:: lua

         math.random()
         math.random( maximum )
         math.random( minimum, maximum )

.. lua:function:: math.randomseed( value )

   Sets value as the "seed" for the pseudo-random number generator. Equal seeds produce equal sequences of numbers.

   :param value: int, seed of the pseudo-random number generator
   :return: A uniform pseudo-random real number or integer (depending on parameters)
   :rtype: integer
   :syntax:

      .. code-block:: lua

         math.randomseed( value )

.. lua:function:: math.sin( value )

   This function returns the sine of `value` (assumed to be in radians).

   :param value: int or float, compute the sine of this number
   :return: Sine of value
   :syntax:

      .. code-block:: lua

         math.sin( value )

.. lua:function:: math.sinh( value )

   This function returns hyperbolic sine of `value`.

   :param value: int or float, compute the hyperbolic sine of this number
   :return: Hyperbolic sine of value
   :syntax:

      .. code-block:: lua

         math.sinh( value )

.. lua:function:: math.tan( value )

   This function returns the tangent of `value` (assumed to be in radians).

   :param value: int or float, compute the tangent of this number
   :return: Tangent of value
   :syntax:

      .. code-block:: lua

         math.tan( value )

.. lua:function:: math.tanh( value )

   This function returns hyperbolic tangent of `value`.

   :param value: int or float, compute the hyperbolic tangent of this number
   :return: Hyperbolic tangent of value
   :syntax:

      .. code-block:: lua

         math.tanh( value )

.. lua:function:: math.sqrt( value )

   This function computes the square root of `value`. You can also use the expression `value^0.5` to compute this value.

   :param value: int or float, compute the square root of this number
   :return: Square root of value
   :syntax:

      .. code-block:: lua

         math.sqrt( value )

.. lua:function:: math.tointeger( value )

   If `value` is convertible to an integer, returns that integer. Otherwise returns **nil**.

   :param value: float, value to convert to integer
   :return: `value` converted to an integer, or nil
   :rtype: integer
   :syntax:

      .. code-block:: lua

         math.tointeger( value )

.. lua:function:: math.type( value )

   This function returns "integer" if `value` is an integer, "float" if it is a float, or **nil** if `value` is not a number.

   :param value: int or float, get the type of this value
   :return: "integer" or "float"
   :rtype: integer
   :syntax:

      .. code-block:: lua

         math.type( value )

.. lua:function:: math.ult( m, n )

   This function returns a boolean, true if integer `m` is below integer `n` when they are compared as unsigned integers.

   :param m: value for m
   :type m: integer
   :param n: value for n
   :type n: integer
   :return: true if `m` is below integer `n` when compared as unsigned
   :rtype: boolean
   :syntax:

      .. code-block:: lua

         math.ult( m, n )

.. lua:attribute:: math.huge: const

   .. symbol:: lua-api const

   A value larger than or equal to any other numerical value.

   :return: A value larger than or equal to any other numerical value
   :syntax:

      .. code-block:: lua

         math.huge

.. lua:attribute:: math.pi: const

   .. symbol:: lua-api const

   The value of **pi**.

   :return: Value of pi
   :syntax:

      .. code-block:: lua

         math.pi

.. lua:attribute:: math.maxinteger: const

   .. symbol:: lua-api const

   Specifies an integer with the maximum value for an integer

   :return: Maximum value for an integer
   :rtype: integer
   :syntax:

      .. code-block:: lua

         math.maxinteger

.. lua:attribute:: math.mininteger: const

   .. symbol:: lua-api const

   Specifies an integer with the minimum value for an integer

   :return: Minimum value for an integer
   :rtype: integer
   :syntax:

      .. code-block:: lua

         math.mininteger

Date and Time
-------------

.. lua:function:: os.clock()

   Returns an approximation of the amount in seconds of CPU time used by the program.

   :return: Approximation of the amount in seconds of CPU time used by the program.
   :rtype: number
   :syntax:

      .. code-block:: lua

         os.clock()

.. lua:function:: os.difftime( t2, t1 )

   Returns the number of seconds from time `t1` to time `t2`. In POSIX, Windows, and some other systems, this value is exactly `t2-t1`.

   :param t2: Ending time
   :param t1: Starting time
   :return: Number of seconds from time `t1` to time `t2`.
   :rtype: number
   :syntax:

      .. code-block:: lua

         os.difftime( t2, t1 )

.. lua:function:: os.date( format )

   Returns a string or a table containing the date and time, formatted according to the given string `format`.

   If the `time` argument is present, this is the time to be formatted (see the `os.time` function for a description of this value). Otherwise, `date` formats the current time.

   If format starts with '!', then the date is formatted in Coordinated Universal Time. After this optional character, if format is the string ``*t``, then date returns a table with the following fields: year (four digits), month (1--12), day (1--31), hour (0--23), min (0--59), sec (0--61), wday (weekday, Sunday is 1), yday (day of the year), and isdst (daylight saving flag, a boolean).

   If `format` is not ``*t``, then `date` returns the date as a string, formatted according to the same rules as the C function `strftime`.

   When called without arguments, date returns a reasonable date and time representation that depends on the host system and on the current locale (that is, `os.date()` is equivalent to `os.date('%c')`).

   :param format: String used to format the returned date
   :param time: If the time argument is present, this is the time to be formatted (see the os.time function for a description of this value).
   :return: A string or a table containing the date and time.
   :rtype: string
   :syntax:

      .. code-block:: lua

         os.date()
         os.date( format )
         os.date( format, time )

.. lua:function:: os.setlocale( locale )

   Sets the current locale of the program. `locale` is a string specifying a locale; `category` is an optional string describing which category to change: "all", "collate", "ctype", "monetary", "numeric", or "time"; the default category is "all". The function returns the name of the new locale, or nil if the request cannot be honored.

   If `locale` is the empty string, the current locale is set to an implementation-defined native locale. If `locale` is the string "C", the current locale is set to the standard C locale.

   When called with `nil` as the first argument, this function only returns the name of the current locale for the given category.

   :param locale: String specifying a locale, can be nil or the empty string.
   :param category: String specifying a category to set, can be "all", "collate", "ctype", "monetary", "numeric", or "time"
   :return: When called with `nil` for the first argument, returns the name of the current locale for the given category.
   :syntax:

      .. code-block:: lua

         os.setlocale( locale )
         os.setlocale( locale, category )

.. lua:function:: os.time()

   Returns the current time when called without arguments, or a time representing the date and time specified by the given table. This table must have fields `year`, `month`, and `day`, and may have fields `hour`, `min`, `sec`, and `isdst` (for a description of these fields, see the os.date function).

   The returned value is a number, whose meaning depends on your system. In POSIX, Windows, and some other systems, this number counts the number of seconds since some given start time (the "epoch"). In other systems, the meaning is not specified, and the number returned by `time` can be used only as an argument to `date` and `difftime`.

   :param table: This table must have fields `year`, `month`, and `day`, and may have fields `hour`, `min`, `sec`, and `isdst`
   :return: A number, whose meaning depends on your system. In POSIX, Windows, and some other systems, this number counts the number of seconds since some given start time (the "epoch"). In other systems, the meaning is not specified, and the number returned by `time` can be used only as an argument to `date` and `difftime`.
   :rtype: number
   :syntax:

      .. code-block:: lua

         os.time()
         os.time( table )
