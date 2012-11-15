From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix.patch removed from -mm tree
Date: Thu, 15 Nov 2012 11:54:26 -0800
Message-ID: <20121115195426.D9500100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:58725 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423636Ab2KOTy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 14:54:28 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so215627vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 11:54:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix.patch

This patch was dropped because it was folded into mm-introduce-a-common-interface-for-balloon-pages-mobility.patch

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
mm-redefine-address_spaceassoc_mapping.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix-fix.patch
mm-introduce-compaction-and-migration-for-ballooned-pages.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-introduce-putback_movable_pages.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

