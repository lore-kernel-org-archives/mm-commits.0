From: akpm@linux-foundation.org
Subject: + kbuild-stepping-down-as-maintainer.patch added to -mm tree
Date: Mon, 23 Nov 2009 15:05:33 -0800
Message-ID: <200911232305.nANN5XAT002874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563AbZKWXF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 18:05:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, anibal@debian.org, mmarek@suse.cz, rostedt@goodmis.org


The patch titled
     kbuild: Stepping down as Maintainer
has been added to the -mm tree.  Its filename is
     kbuild-stepping-down-as-maintainer.patch

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
Subject: kbuild: Stepping down as Maintainer
From: Sam Ravnborg <sam@ravnborg.org>

It has been fun but the last year or more it has been a duty and a burden.
So I leave it open for others to take over.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Anibal Monsalve Salazar <anibal@debian.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN MAINTAINERS~kbuild-stepping-down-as-maintainer MAINTAINERS
--- a/MAINTAINERS~kbuild-stepping-down-as-maintainer
+++ a/MAINTAINERS
@@ -2987,11 +2987,8 @@ S:	Maintained
 F:	fs/autofs4/
 
 KERNEL BUILD
-M:	Sam Ravnborg <sam@ravnborg.org>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
 L:	linux-kbuild@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	Documentation/kbuild/
 F:	Makefile
 F:	scripts/Makefile.*
_

Patches currently in -mm which might be from sam@ravnborg.org are

kbuild-stepping-down-as-maintainer.patch
linux-next.patch
x86-_end-symbol-missing-from-symbolmap.patch
kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch
kbuild-generate-modulesbuiltin-fix-2.patch
kconfig-cross_compile-option.patch
kbuild-clean-up-marker.patch
kbuild-clear-marker-out-of-modpost.patch
kbuild-genksyms-properly-consider-export_unused_symbol_gpl.patch
make-debug_bugverbose-default-to-y.patch

