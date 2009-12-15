From: akpm@linux-foundation.org
Subject: [merged] maintainers-new-kbuild-maintainer.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:01 -0800
Message-ID: <200912152150.nBFLo1K9014900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760272AbZLOVul (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:50:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mmarek@suse.cz, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: new kbuild maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-new-kbuild-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: new kbuild maintainer
From: Michal Marek <mmarek@suse.cz>

Sam was fine with handing over kbuild maintainership to me. The git
trees are already in linux-next, a merge request will follow shortly.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-new-kbuild-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-new-kbuild-maintainer
+++ a/MAINTAINERS
@@ -3081,8 +3081,11 @@ S:	Maintained
 F:	fs/autofs4/
 
 KERNEL BUILD
+M:	Michal Marek <mmarek@suse.cz>
+T:	git git://repo.or.cz/linux-kbuild.git for-next
+T:	git git://repo.or.cz/linux-kbuild.git for-linus
 L:	linux-kbuild@vger.kernel.org
-S:	Orphan
+S:	Maintained
 F:	Documentation/kbuild/
 F:	Makefile
 F:	scripts/Makefile.*
_

Patches currently in -mm which might be from mmarek@suse.cz are

origin.patch
linux-next.patch
kconfig-cross_compile-option.patch

