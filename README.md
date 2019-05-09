# Mini Parser

Parser by Salesforce Apex

## Install

## Usage

```apex
Visitor v = new Visitor();
v.run('a = "hello"\nputs a + " apex!"');
System.debug(v.getBuffer());
```