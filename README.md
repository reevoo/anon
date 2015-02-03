# anon

Because ISO say so.

anon can be used to replace personal e-mail addresses with anonymous (fake) ones. This is useful when transferring personally sensitive data.

## Setup

On your command line:
```
gem install anon
```

## Let's Go!

A whole bunch of help is available with

```
anon help
```

A few common use cases:

* Replace all valid e-mail addresses in the file personal.txt with anonymous e-mails. Save the new file as anonymous.txt:
```
anon text personal.txt anonymous.txt
```

* Replace the contents of column 0 and 2 in the file personal.csv with anonymous e-mails. Save the new file as anonymous.csv. The file does not have headers:
```
anon csv personal.csv anonymous.csv 0,2 noheader
```

## In-Code Usage

```ruby

require 'anon/text'
require 'anon/csv'

Anon::Text.anonymise! 'in.txt', 'out.txt'
Anon::CSV.anonymise!  'in.csv', 'out.csv', 
  columns_to_anonymise=[0, 2], 
  has_header=false

```
