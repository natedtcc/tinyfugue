TinyFugue - Rebirth
=====================

////////////////////////////////////////////

Since I wasn't able to get ingwarsw's build to work with SSL, I replaced his socket.c with
the socket.c found in the 5.0b8 build from Sourceforge.

NOTE! All credit for Tinyfugue Rebirth goes to ingwarsw [(https://github.com/ingwarsw/tinyfugue)](https://github.com/ingwarsw/tinyfugue)
Everything else - Ken Keys

////////////////////////////////////////////

This project is meant to give rebirth to TinyFugue MUD client.

Because Ken Keys is not activelly developing it from 6 years and i gathered a lot of pathes over that time in thet time i decided to push them together.

# New features

### Lua support

### New telnet options

	- ATCP
	- GMCP
	- option 102


```
To enable compile with:
	--enable-atcp		enable ATCP support	
	--enable-gmcp		enable GMCP support	
	--enable-option102	enable telnet option 102 support	
```

### New logging options

	- Timestamp logging
	- Ansi logging

## Copyright

Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2002, 2003, 2004, 2005, 2006-2007 Ken Keys (kenkeys@users.sourceforge.net)

http://tinyfugue.sourceforge.net/

[Oryginal README](README.orig)
