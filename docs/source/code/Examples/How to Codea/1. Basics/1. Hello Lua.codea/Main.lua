-- How to Codea
-- Hello World and Lua

-- This is a comment. Anything beginning with '--' will be ignored by the
-- compiler    

-- Functions

-- This is a function in Lua, everything from 'function' until the matching 'end' keyword
-- is run together. Codea calls the setup() function when your program begins
function setup()
    
    -- There are special built-in functions that you can call yourself
    -- Start with the name of the function ('print' in this example) followed by brackets '()'
    -- In this case print takes one 'argument' which is a string (which contains a series of letters)
    -- Strings are contained within quations, Lua supports both single and double quotation marks
    -- but you need to make sure that the begin and end quote match or you will get an error
    print("Hello World!")
    
    -- You can change the argument to whatever string you want and Codea will print 
    -- it in the output panel for you
    print("Hello Codea!")

    -- Locals and Global variables
    
    -- You can create variables to store data for you and use that to control your program
    -- Lua supports local and global variables. A local variable exists only in the scope
    -- where you create it. A function is a type of scope. We'll cover scopes more later
    local x = "Hello Local Variable!"
    print(x)
    
    -- The above code creates a local variable (named: x) and uses it as an argument for the print
    -- function. This variable is local and therefore only exists in the scope of this function
    
    g = "Hello Global Variable!"
    print(g)
    
    -- The above code creates a global variable (named: g) and does the same thing. The only
    -- difference is that now g exists everywhere in the program, and will continue to exist
    -- outside the scope of this function
    
    -- Using nil
    
    -- In Lua whenever trying to access a variable that does not exist, the value nil will
    -- be returned. Nil represents nothing and is useful in many ways. You can also assign
    -- nil to a variable to destroy it
    
    g = nil -- destroy g
    print(g)
    
    -- Flow Control
    
    -- In order to make a program do what we want, we need to compare variables and execute
    -- code. This is called flow control and is a key cornerstone of programming
    
    -- To conditionally execute some code we use an 'if' statement. The 'if' keyword is 
    -- followed by a condition, which eqaluates the logical thruth of something.
    -- In this case we use 'foo == 1', which mean check if the variable named 'foo' is equal
    -- to the value 1. This is always followed by 'then' and subsequently ended with the 'end'
    -- keyword. Everything between 'then' and 'end' is executed if the condition is true
    local foo = 42
    
    if foo == 42 then
        print("Foo is equal to 42!")
    end
    
    -- We can also chain together multiple branches, including 'else' and 'elseif' which execute 
    -- when the condition is false, or some other condition is true when the previous one isn't
    
    foo = 21
    
    if foo == 42 then
        print("Foo is equal to 42!")
    elseif foo == 21 then
        print("Foo is equal to 21!")
    else
        print("Foo is equal to something else?!?")
    end
    
end

function draw()
    background(42)
end

function touched(touch)
end
