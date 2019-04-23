PROGNAME      := ssh-getkey-gitlab
CONFNAME      := getkey-gitlab.conf

prefix        := /usr/local
cachedir      := /var/cache
sbindir       := $(prefix)/sbin
sysconfdir    := /etc

INSTALL       := install

install:
	$(INSTALL) -m 755 -o root -g root -D $(PROGNAME) $(DESTDIR)$(sbindir)/$(PROGNAME)
	$(INSTALL) -m 644 -o root -g root -D $(PROGNAME).conf $(DESTDIR)$(sysconfdir)/ssh/$(CONFNAME)
	$(INSTALL) -m 700 -o sshd -g nogroup -d $(DESTDIR)$(cachedir)/$(PROGNAME)

uninstall:
	rm $(DESTDIR)$(sbindir)/$(PROGNAME)
	rm $(DESTDIR)$(sysconfdir)/ssh/$(CONFNAME)
	rm -f $(DESTDIR)$(cachedir)/$(PROGNAME)/*.keys
	rmdir $(DESTDIR)$(cachedir)/$(PROGNAME)

.PHONY: install uninstall
