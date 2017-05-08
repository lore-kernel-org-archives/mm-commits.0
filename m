From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
 removed from -mm tree
Date: Mon, 08 May 2017 15:38:00 -0700
Message-ID: <5910f348.DP8HcqECPzON13CH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40424 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdEHWiB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:38:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch

This patch was dropped because it was folded into mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix

merge fix

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix
+++ a/mm/page_alloc.c
@@ -2013,7 +2013,7 @@ static void steal_suitable_fallback(stru
 	}
 
 	/* moving whole block can fail due to zone boundary conditions */
-	if (!pages)
+	if (!free_pages)
 		goto single_page;
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
dax-add-tracepoint-to-dax_writeback_one-fix.patch
drivers-staging-ccree-ssi_hashc-fix-build-with-gcc-444.patch

