From: akpm@linux-foundation.org
Subject: + mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix.patch added to -mm tree
Date: Wed, 07 Nov 2012 16:42:28 -0800
Message-ID: <20121108004228.8AEF1100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:62657 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab2KHAm3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2012 19:42:29 -0500
Received: by mail-vc0-f202.google.com with SMTP id fy27so264007vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Nov 2012 16:42:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aquini@redhat.com


The patch titled
     Subject: mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix
has been added to the -mm tree.  Its filename is
     mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/Makefile~mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix mm/Makefile
--- a/mm/Makefile~mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix
+++ a/mm/Makefile
@@ -16,7 +16,8 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   util.o mmzone.o vmstat.o backing-dev.o \
 			   mm_init.o mmu_context.o percpu.o slab_common.o \
-			   compaction.o interval_tree.o $(mmu-y)
+			   compaction.o balloon_compaction.o \
+			   interval_tree.o $(mmu-y)
 
 obj-y += init-mm.o
 
@@ -57,4 +58,3 @@ obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak
 obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
 obj-$(CONFIG_CLEANCACHE) += cleancache.o
 obj-$(CONFIG_MEMORY_ISOLATION) += page_isolation.o
-obj-$(CONFIG_BALLOON_COMPACTION) += balloon_compaction.o
_

Patches currently in -mm which might be from aquini@redhat.com are

mm-adjust-address_space_operationsmigratepage-return-code.patch
mm-adjust-address_space_operationsmigratepage-return-code-fix.patch
mm-redefine-address_spaceassoc_mapping.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix.patch
mm-introduce-compaction-and-migration-for-ballooned-pages.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch
mm-introduce-putback_movable_pages.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

