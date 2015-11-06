From: akpm@linux-foundation.org
Subject: [folded-merged] mm-vmstatc-uninline-node_page_state-fix.patch
 removed from -mm tree
Date: Thu, 05 Nov 2015 18:26:41 -0800
Message-ID: <563c0fe1.yXdyw2BA1vXuFTAr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFC0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstatc-uninline-node_page_state-fix
has been removed from the -mm tree.  Its filename was
     mm-vmstatc-uninline-node_page_state-fix.patch

This patch was dropped because it was folded into mm-vmstatc-uninline-node_page_state.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmstatc-uninline-node_page_state-fix

fix comment - node_page_state() is only for userspace meminfo display and
shouldn't be called frequently

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/vmstat.c~mm-vmstatc-uninline-node_page_state-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstatc-uninline-node_page_state-fix
+++ a/mm/vmstat.c
@@ -593,9 +593,7 @@ void zone_statistics(struct zone *prefer
 }
 
 /*
- * Determine the per node value of a stat item. This function
- * is called frequently in a NUMA machine, so try to be as
- * frugal as possible.
+ * Determine the per node value of a stat item.
  */
 unsigned long node_page_state(int node, enum zone_stat_item item)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
mm-vmstatc-uninline-node_page_state.patch
mm-cmac-suppress-warning.patch
memcg-fix-thresholds-for-32b-architectures-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix.patch

