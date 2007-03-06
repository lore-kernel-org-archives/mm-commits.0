From: akpm@linux-foundation.org
Subject: - rcu-preemptible-rcu-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:24:13 -0800
Message-ID: <200703060124.l261OEpg007584@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45392 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894AbXCFBaq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:30:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     PREEMPT_RCU has stricter needs: updated comment on SLAB_DESTROY_BY_RCU
has been removed from the -mm tree.  Its filename was
     rcu-preemptible-rcu-fix.patch

This patch was dropped because it was folded into rcu-preemptible-rcu.patch

------------------------------------------------------
Subject: PREEMPT_RCU has stricter needs: updated comment on SLAB_DESTROY_BY_RCU
From: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~rcu-preemptible-rcu-fix mm/slab.c
--- a/mm/slab.c~rcu-preemptible-rcu-fix
+++ a/mm/slab.c
@@ -238,7 +238,7 @@ struct slab {
  * other kind of object (which our subsystem's lock might corrupt).
  *
  * rcu_read_lock before reading the address, then rcu_read_unlock after
- * taking the spinlock within the structure expected at that address.
+ * releasing the spinlock within the structure expected at that address.
  *
  * We assume struct slab_rcu can overlay struct slab when destroying.
  */
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
free-swap-space-of-reactivated-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rcu-preemptible-rcu.patch
rcu-preemptible-rcu-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
