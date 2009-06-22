From: akpm@linux-foundation.org
Subject: [merged] maintainers-kmemtrace-pattern-update.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:56 -0700
Message-ID: <200906221700.n5MH0uqY010309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbZFVRCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, eduard.munteanu@linux360.ro, mingo@elte.hu, penberg@cs.helsinki.fi, rostedt@goodmis.org, zhaolei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: kmemtrace pattern update
has been removed from the -mm tree.  Its filename was
     maintainers-kmemtrace-pattern-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: kmemtrace pattern update
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-kmemtrace-pattern-update MAINTAINERS
--- a/MAINTAINERS~maintainers-kmemtrace-pattern-update
+++ a/MAINTAINERS
@@ -3406,7 +3406,7 @@ P:	Eduard - Gabriel Munteanu
 M:	eduard.munteanu@linux360.ro
 S:	Maintained
 F:	Documentation/trace/kmemtrace.txt
-F:	include/trace/kmemtrace.h
+F:	include/linux/kmemtrace.h
 F:	kernel/trace/kmemtrace.c
 
 KPROBES
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

