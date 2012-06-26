From: akpm@linux-foundation.org
Subject: + mm-remove-unused-lru_all_evictable.patch added to -mm tree
Date: Tue, 26 Jun 2012 12:48:40 -0700
Message-ID: <20120626194840.ADA3BA01ED@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:38184 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab2FZTsm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jun 2012 15:48:42 -0400
Received: by fat25 with SMTP id 25so14297fat.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2012 12:48:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liwp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, riel@redhat.com


The patch titled
     Subject: mm: remove unused LRU_ALL_EVICTABLE
has been added to the -mm tree.  Its filename is
     mm-remove-unused-lru_all_evictable.patch

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
Subject: mm: remove unused LRU_ALL_EVICTABLE

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-remove-unused-lru_all_evictable include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-remove-unused-lru_all_evictable
+++ a/include/linux/mmzone.h
@@ -208,7 +208,6 @@ struct lruvec {
 /* Mask used at gathering information at once (see memcontrol.c) */
 #define LRU_ALL_FILE (BIT(LRU_INACTIVE_FILE) | BIT(LRU_ACTIVE_FILE))
 #define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
-#define LRU_ALL_EVICTABLE (LRU_ALL_FILE | LRU_ALL_ANON)
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
 /* Isolate clean file */
_
Subject: Subject: mm: remove unused LRU_ALL_EVICTABLE

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

linux-next.patch
mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch
mm-cleanup-on-the-comments-of-zone_reclaim_stat.patch
mm-fix-page-reclaim-comment-error.patch
mm-remove-unused-lru_all_evictable.patch

