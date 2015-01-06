# anon

Because ISO say so.

anon can be used to replace personal e-mail addresses with anonymous (fake) ones. This is useful when transferring personally sensitive data.

## Setup

```
gem install time_difference
```

## Let's Go!

A whole bunch of help is available with

```
ruby anon.rb help
```

A few common use cases:

* Replace all valid e-mail addresses in the file personal.txt with anonymous e-mails. Save the new file as anonymous.txt:
```
ruby anon.rb text personal.txt anonymous.txt
```

* Replace the contents of column 0 and 2 in the file personal.csv with anonymous e-mails. Save the new file as anonymous.csv. The file does not have headers:
```
ruby anon.rb csv personal.csv anonymous.csv 0,2 noheader
```
