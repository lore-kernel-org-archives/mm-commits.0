From: akpm@google.com
Subject: + ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch added to -mm tree
Date: Wed, 28 Sep 2011 14:33:31 -0700
Message-ID: <201109282133.p8SLXWBY010542@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:2268 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab1I1Vdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2011 17:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@google.com, amwang@redhat.com, dledford@redhat.com


The patch titled
     Subject: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@google.com>
Subject: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes

Cc: Amerigo Wang <amwang@redhat.com>

ERROR: Macros with complex values should be enclosed in parenthesis
#87: FILE: include/linux/ipc_namespace.h:126:
+#define DFLT_MSGSIZEMAX		1024*1024

ERROR: Macros with complex values should be enclosed in parenthesis
#88: FILE: include/linux/ipc_namespace.h:127:
+#define HARD_MSGSIZEMAX	     16*1024*1024

total: 2 errors, 0 warnings, 75 lines checked

./patches/ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 include/linux/ipc_namespace.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes
+++ a/include/linux/ipc_namespace.h
@@ -123,8 +123,8 @@ extern int mq_init_ns(struct ipc_namespa
 #define HARD_MSGMAX		    65536
 #define MIN_MSGSIZEMAX		      128
 #define DFLT_MSGSIZE		     8192U
-#define DFLT_MSGSIZEMAX		1024*1024
-#define HARD_MSGSIZEMAX	     16*1024*1024
+#define DFLT_MSGSIZEMAX		(1024*1024)
+#define HARD_MSGSIZEMAX	     (16*1024*1024)
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 #endif
_
Subject: Subject: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes

Patches currently in -mm which might be from akpm@google.com are

linux-next.patch
drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch
loop-cleanup-set_status-interface-checkpatch-fixes.patch

