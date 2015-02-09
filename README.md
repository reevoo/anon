# anon

Because ISO say so.

anon can be used to replace personal e-mail addresses with anonymous (fake) ones. This is useful when transferring personally sensitive data.

## Features

- Scans and replaces e-mail addresses in a file.
- Replaces all data in one or more CSV columns with anonymous e-mail addresses. (Supports auto-detection of e-mail columns or use of column headers/indices)
- The same personal e-mail address will be replaced with the same anonymous e-mail address within the file.
- Command-Line Interface with I/O support

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
anon text -i personal.txt -o anonymous.txt
```

* Replace the contents of column 0 and 2 in the file personal.csv with anonymous e-mails. Save the new file as anonymous.csv. The file does not have headers:
```
anon csv -i personal.csv -o anonymous.csv -c 0,2 --no-header
```

## In-Code Usage

```ruby

require 'anon/text'

input = File.read('in.txt')
output = File.read('out.txt', 'w')

Anon::Text.anonymise! input, output

require 'anon/csv'

input = File.read('in.csv')
Anon::CSV.anonymise!  input, $stdout,
  columns_to_anonymise=[0, 2], 
  has_header=false

```
