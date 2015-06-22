BEGIN {
	sec = "null";
}
/^\[.+\]$/ {
	dirtysec = $1;
	sec = substr(dirtysec, 2, length(dirtysec) - 2);
}

!/^\[.+\]/ {
	if(NF == 0) { next; }
	printf "%s.%s\n", sec, $0;
}
