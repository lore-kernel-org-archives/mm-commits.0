From: akpm@linux-foundation.org
Subject: - arm26-remove-it-again.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:52:08 -0800
Message-ID: <200711060552.lA65q8LO007249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbXKFFwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:52:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     arm26: remove it again
has been removed from the -mm tree.  Its filename was
     arm26-remove-it-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arm26: remove it again
From: Hugh Dickins <hugh@veritas.com>

A tiny vestige of arm26 has appeared: remove it again.

(akpm: someone (tm) needs to remove include/asm-arm26/ too)

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm26/irq_regs.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/asm-arm26/irq_regs.h~arm26-remove-it-again /dev/null
--- a/include/asm-arm26/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
i386-and-x86_64-randomize-brk-fix-2.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
memory-controller-memory-accounting-v7.patch
prio_tree-debugging-patch.patch
