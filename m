From: akpm@linux-foundation.org
Subject: + maintainers-update-kmemtrace-pattern-after-file-rename.patch added to -mm tree
Date: Sat, 18 Apr 2009 14:26:42 -0700
Message-ID: <200904182126.n3ILQgB3005128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262AbZDRVaf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Apr 2009 17:30:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, eduard.munteanu@linux360.ro, penberg@cs.helsinki.fi


The patch titled
     MAINTAINERS: update KMEMTRACE pattern after file rename
has been added to the -mm tree.  Its filename is
     maintainers-update-kmemtrace-pattern-after-file-rename.patch

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
Subject: MAINTAINERS: update KMEMTRACE pattern after file rename
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-kmemtrace-pattern-after-file-rename MAINTAINERS
--- a/MAINTAINERS~maintainers-update-kmemtrace-pattern-after-file-rename
+++ a/MAINTAINERS
@@ -3324,7 +3324,7 @@ P:	Eduard - Gabriel Munteanu
 M:	eduard.munteanu@linux360.ro
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
-F:	Documentation/vm/kmemtrace.txt
+F:	Documentation/trace/kmemtrace.txt
 F:	include/trace/kmemtrace.h
 F:	kernel/trace/kmemtrace.c
 
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-remove-include-asm-suspend-file-patterns.patch
maintainers-update-kmemtrace-pattern-after-file-rename.patch
linux-next.patch

