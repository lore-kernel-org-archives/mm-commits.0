From: akpm@linux-foundation.org
Subject: +
 mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch added to -mm tree
Date: Thu, 11 Aug 2016 14:31:03 -0700
Message-ID: <57acee97.dBFPTeuvpt+dBM5o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbcHKVbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 17:31:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

