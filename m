From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 07 Oct 2016 16:32:25 -0700
Message-ID: <57f83089.OYZ4gfW96lvnWCHU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38268 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbcJGXc0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:32:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes

fix typo in comment

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes mm/compaction.c
--- a/mm/compaction.c~mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes
+++ a/mm/compaction.c
@@ -1492,7 +1492,7 @@ static enum compact_result compact_zone(
 
 	/*
 	 * Setup to move all movable pages to the end of the zone. Used cached
-	 * information on where the scanners should start (unless we explictly
+	 * information on where the scanners should start (unless we explicitly
 	 * want to compact the whole zone), but check that it is initialised
 	 * by ensuring the values are within zone boundaries.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
a.patch

