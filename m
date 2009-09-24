From: akpm@linux-foundation.org
Subject: + maintainers-update-tracing-section.patch added to -mm tree
Date: Thu, 24 Sep 2009 14:42:40 -0700
Message-ID: <200909242142.n8OLgeMG026462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbZIXVnj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 17:43:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     MAINTAINERS: update TRACING section
has been added to the -mm tree.  Its filename is
     maintainers-update-tracing-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: MAINTAINERS: update TRACING section
=46rom: Joe Perches <joe@perches.com>

Move to alphabetic position
Use single line F: entries

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN MAINTAINERS~maintainers-update-tracing-section MAINTAINERS
--- a/MAINTAINERS~maintainers-update-tracing-section
+++ a/MAINTAINERS
@@ -2183,18 +2183,6 @@ F:	Documentation/filesystems/caching/
 F:	fs/fscache/
 F:	include/linux/fscache*.h
=20
-TRACING
-M:	Steven Rostedt <rostedt@goodmis.org>
-M:	Frederic Weisbecker <fweisbec@gmail.com>
-M:	Ingo Molnar <mingo@redhat.com>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip=
=2Egit tracing/core
-S:	Maintained
-F:	Documentation/trace/ftrace.txt
-F:	arch/*/*/*/ftrace.h
-F:	arch/*/kernel/ftrace.c
-F:	include/*/ftrace.h include/trace/ include/linux/trace*.h
-F:	kernel/trace/
-
 FUJITSU FR-V (FRV) PORT
 M:	David Howells <dhowells@redhat.com>
 S:	Maintained
@@ -5150,6 +5138,20 @@ L:	tpmdd-devel@lists.sourceforge.net (mo
 S:	Maintained
 F:	drivers/char/tpm/
=20
+TRACING
+M:	Steven Rostedt <rostedt@goodmis.org>
+M:	Frederic Weisbecker <fweisbec@gmail.com>
+M:	Ingo Molnar <mingo@redhat.com>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip=
=2Egit tracing/core
+S:	Maintained
+F:	Documentation/trace/ftrace.txt
+F:	arch/*/*/*/ftrace.h
+F:	arch/*/kernel/ftrace.c
+F:	include/*/ftrace.h
+F:	include/linux/trace*.h
+F:	include/trace/
+F:	kernel/trace/
+
 TRIVIAL PATCHES
 M:	Jiri Kosina <trivial@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-update-generic-uio-for-pci-devices.patch
maintainers-update-tracing-section.patch
maintainers-update-omap-tony-lindgren-email-name.patch
maintainers-change-atm-mailing-list-to-moderated.patch
maintainers-use-tab-not-spaces-after-field-types.patch
maintainers-janitors-status-set-to-odd-fixes.patch
maintainers-update-score-architecture-name-style-and-add-file-pattern.p=
atch
maintainers-simple-firmware-interface-update-email-style.patch
maintainers-winbond-cir-integrate-p-m-lines-fixup-david-h=E4rdemans-nam=
e.patch
maintainers-fix-up-peripheral-spelling.patch
maintainers-update-wolfson-microelectronics.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
