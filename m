From: akpm@linux-foundation.org
Subject: + arm26-remove-it-again.patch added to -mm tree
Date: Thu, 01 Nov 2007 14:05:47 -0700
Message-ID: <200711012105.lA1L5lor015394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477AbXKAVGX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 17:06:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     arm26: remove it again
has been added to the -mm tree.  Its filename is
     arm26-remove-it-again.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
arm26-remove-it-again.patch
i386-and-x86_64-randomize-brk-fix-2.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
memory-controller-memory-accounting-v7.patch
prio_tree-debugging-patch.patch
