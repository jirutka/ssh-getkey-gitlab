PROGNAME      := ssh-getkey-gitlab
CONFNAME      := getkey-gitlab.conf

prefix        := /usr/local
cachedir      := /var/cache
sbindir       := $(prefix)/sbin
sysconfdir    := /etc

INSTALL       := install
GIT           := git
SED           := sed


#: Install the script, configuration file and prepare the cache directory.
install:
	$(INSTALL) -m 755 -o root -g root -D $(PROGNAME) $(DESTDIR)$(sbindir)/$(PROGNAME)
	$(INSTALL) -m 644 -o root -g root -D $(PROGNAME).conf $(DESTDIR)$(sysconfdir)/ssh/$(CONFNAME)
	$(INSTALL) -m 700 -o sshd -g nogroup -d $(DESTDIR)$(cachedir)/$(PROGNAME)

#: Remove the script, configuration file and the cache directory.
uninstall:
	rm $(DESTDIR)$(sbindir)/$(PROGNAME)
	rm $(DESTDIR)$(sysconfdir)/ssh/$(CONFNAME)
	rm -f $(DESTDIR)$(cachedir)/$(PROGNAME)/*.keys
	rmdir $(DESTDIR)$(cachedir)/$(PROGNAME)

#: Update version in the script and README.adoc to $VERSION.
bump-version:
	test -n "$(VERSION)"  # $$VERSION
	$(SED) -E -i "s/^(readonly VERSION)=.*/\1='$(VERSION)'/" $(PROGNAME)
	$(SED) -E -i "s/^(:version:).*/\1 $(VERSION)/" README.adoc

#: Bump version to $VERSION, create release commit and tag.
release: .check-git-clean | bump-version
	test -n "$(VERSION)"  # $$VERSION
	$(GIT) add .
	$(GIT) commit -m "Release version $(VERSION)"
	$(GIT) tag -s v$(VERSION) -m v$(VERSION)

#: Print list of targets.
help:
	@printf '%s\n\n' 'List of targets:'
	@$(SED) -En '/^#:.*/{ N; s/^#: (.*)\n([A-Za-z0-9_-]+).*/\2 \1/p }' $(MAKEFILE_LIST) \
		| while read label desc; do printf '%-20s %s\n' "$$label" "$$desc"; done

.check-git-clean:
	@test -z "$(shell $(GIT) status --porcelain)" \
		|| { echo 'You have uncommitted changes!' >&2; exit 1; }

.PHONY: install uninstall bump-version release help .check-git-clean
