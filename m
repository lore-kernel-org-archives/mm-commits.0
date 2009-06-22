From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-ftrace-documentation-pattern.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:50 -0700
Message-ID: <200906221700.n5MH0oVB010201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbZFVRKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:10:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, rdunlap@xenotime.net, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update Ftrace documentation pattern
has been removed from the -mm tree.  Its filename was
     maintainers-update-ftrace-documentation-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

