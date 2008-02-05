From: akpm@linux-foundation.org
Subject: - slob-correct-kconfig-description.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:46 -0800
Message-ID: <200802052232.m15MWRrQ012328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762271AbYBEWlJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     slob: correct Kconfig description
has been removed from the -mm tree.  Its filename was
     slob-correct-kconfig-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slob: correct Kconfig description
From: Matt Mackall <mpm@selenic.com>

Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN init/Kconfig~slob-correct-kconfig-description init/Kconfig
--- a/init/Kconfig~slob-correct-kconfig-description
+++ a/init/Kconfig
@@ -656,11 +656,9 @@ config SLOB
 	depends on EMBEDDED
 	bool "SLOB (Simple Allocator)"
 	help
-	   SLOB replaces the SLAB allocator with a drastically simpler
-	   allocator.  SLOB is more space efficient than SLAB but does not
-	   scale well (single lock for all operations) and is also highly
-	   susceptible to fragmentation. SLUB can accomplish a higher object
-	   density. It is usually better to use SLUB instead of SLOB.
+	   SLOB replaces the stock allocator with a drastically simpler
+	   allocator. SLOB is generally more space efficient but
+	   does not perform as well on large systems.
 
 endchoice
 
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
random-clean-up-checkpatch-complaints.patch
random-clean-up-checkpatch-complaints-fix.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
random-add-async-notification-support-to-dev-random.patch
