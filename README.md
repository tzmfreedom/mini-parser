# Mini Parser

Parser by Salesforce Apex

## Install

## Usage

```apex
Visitor v = new Visitor();
v.run('a = "hello"\nputs a + " apex!"');
System.debug(v.getBuffer());
```

## Language Spec

```ruby
# dynamic variable declaration
a = 123

# function call
puts "hello"

# for loop
for i = 0; i < 10; i++ {
  puts i
}

# while loop
while true {
  puts i
  break
}
```
