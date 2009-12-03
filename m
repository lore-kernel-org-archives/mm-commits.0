From: akpm@linux-foundation.org
Subject: [merged] kbuild-stepping-down-as-maintainer.patch removed from -mm tree
Date: Thu, 03 Dec 2009 12:35:53 -0800
Message-ID: <200912032035.nB3KZraC010962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbZLCUgV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 15:36:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, anibal@debian.org, mmarek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: stepping down as maintainer
has been removed from the -mm tree.  Its filename was
     kbuild-stepping-down-as-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: stepping down as maintainer
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
@@ -3015,11 +3015,8 @@ S:	Maintained
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

linux-next.patch
x86-_end-symbol-missing-from-symbolmap.patch
kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch
kbuild-generate-modulesbuiltin-fix-2.patch
kconfig-cross_compile-option.patch
kbuild-genksyms-properly-consider-export_unused_symbol_gpl.patch
make-debug_bugverbose-default-to-y.patch

