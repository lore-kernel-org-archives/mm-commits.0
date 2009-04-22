From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-kmemtrace-pattern-after-file-rename.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:30:25 -0700
Message-ID: <200904221830.n3MIUPbt006179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754125AbZDVSeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:34:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, eduard.munteanu@linux360.ro, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update KMEMTRACE pattern after file rename
has been removed from the -mm tree.  Its filename was
     maintainers-update-kmemtrace-pattern-after-file-rename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -3339,7 +3339,7 @@ P:	Eduard - Gabriel Munteanu
 M:	eduard.munteanu@linux360.ro
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
-F:	Documentation/vm/kmemtrace.txt
+F:	Documentation/trace/kmemtrace.txt
 F:	include/trace/kmemtrace.h
 F:	kernel/trace/kmemtrace.c
 
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch

