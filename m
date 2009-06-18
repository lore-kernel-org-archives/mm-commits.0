From: akpm@linux-foundation.org
Subject: + maintainers-update-ftrace-documentation-pattern.patch added to -mm tree
Date: Thu, 18 Jun 2009 16:34:36 -0700
Message-ID: <200906182334.n5INYalG018097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753392AbZFRXfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 19:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, rdunlap@xenotime.net, rostedt@goodmis.org


The patch titled
     MAINTAINERS: update Ftrace documentation pattern
has been added to the -mm tree.  Its filename is
     maintainers-update-ftrace-documentation-pattern.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update Ftrace documentation pattern
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-ftrace-documentation-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-update-ftrace-documentation-pattern
+++ a/MAINTAINERS
@@ -2390,7 +2390,7 @@ FTRACE
 P:	Steven Rostedt
 M:	rostedt@goodmis.org
 S:	Maintained
-F:	Documentation/ftrace.txt
+F:	Documentation/trace/ftrace.txt
 F:	arch/*/*/*/ftrace.h
 F:	arch/*/kernel/ftrace.c
 F:	include/*/ftrace.h
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
bootmemc-avoid-c90-declaration-warning.patch
bootmemc-avoid-c90-declaration-warning-cleanup.patch
maintainers-pair-names-addresses-in-edac-i82975x.patch
maintainers-fix-atheros-pattern-paths.patch
maintainers-update-ftrace-documentation-pattern.patch
maintainers-update-wirelessh-path.patch
maintainers-ieee802154-fix-pattern-typo.patch
maintainers-kmemtrace-pattern-update.patch
linux-next.patch

