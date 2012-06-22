From: akpm@linux-foundation.org
Subject: + mm-cleanup-on-the-comments-of-zone_reclaim_stat.patch added to -mm tree
Date: Fri, 22 Jun 2012 13:58:20 -0700
Message-ID: <20120622205820.484E4A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:39750 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab2FVU6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jun 2012 16:58:21 -0400
Received: by ggeh3 with SMTP id h3so237189gge.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Jun 2012 13:58:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liwp@linux.vnet.ibm.com, liwp.linux@gmail.com


The patch titled
     Subject: mm: fix zone_reclaim_stat() comment
has been added to the -mm tree.  Its filename is
     mm-cleanup-on-the-comments-of-zone_reclaim_stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: mm: fix zone_reclaim_stat() comment

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-cleanup-on-the-comments-of-zone_reclaim_stat include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-cleanup-on-the-comments-of-zone_reclaim_stat
+++ a/include/linux/mmzone.h
@@ -187,7 +187,7 @@ static inline int is_unevictable_lru(enu
 struct zone_reclaim_stat {
 	/*
 	 * The pageout code in vmscan.c keeps track of how many of the
-	 * mem/swap backed and file backed pages are refeferenced.
+	 * mem/swap backed and file backed pages are referenced.
 	 * The higher the rotated/scanned ratio, the more valuable
 	 * that cache is.
 	 *
_
Subject: Subject: mm: fix zone_reclaim_stat() comment

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

origin.patch
linux-next.patch
mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch
mm-cleanup-on-the-comments-of-zone_reclaim_stat.patch

