From: akpm@linux-foundation.org
Subject: + ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch added to -mm tree
Date: Fri, 27 Apr 2012 16:01:49 -0700
Message-ID: <20120427230149.A1448A0270@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:40731 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab2D0XBx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 19:01:53 -0400
Received: by vbnl22 with SMTP id l22so142620vbn.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 16:01:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, dledford@redhat.com


The patch titled
     Subject: ipc/mqueue: using vmalloc requires including vmalloc.h
has been added to the -mm tree.  Its filename is
     ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: ipc/mqueue: using vmalloc requires including vmalloc.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN ipc/mqueue.c~ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix
+++ a/ipc/mqueue.c
@@ -24,6 +24,7 @@
 #include <linux/mqueue.h>
 #include <linux/msg.h>
 #include <linux/skbuff.h>
+#include <linux/vmalloc.h>
 #include <linux/netlink.h>
 #include <linux/syscalls.h>
 #include <linux/audit.h>
_
Subject: Subject: ipc/mqueue: using vmalloc requires including vmalloc.h

Patches currently in -mm which might be from sfr@canb.auug.org.au are

linux-next.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch

