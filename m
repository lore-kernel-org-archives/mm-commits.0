From: akpm@linux-foundation.org
Subject: + maintainers-new-kbuild-maintainer.patch added to -mm tree
Date: Tue, 08 Dec 2009 15:19:06 -0800
Message-ID: <200912082319.nB8NJ6Xh021157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756364AbZLHXTj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 18:19:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mmarek@suse.cz, sam@ravnborg.org


The patch titled
     MAINTAINERS: new kbuild maintainer
has been added to the -mm tree.  Its filename is
     maintainers-new-kbuild-maintainer.patch

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
@@ -3098,8 +3098,11 @@ S:	Maintained
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

maintainers-new-kbuild-maintainer.patch
linux-next.patch
kconfig-cross_compile-option.patch

