From: akpm@linux-foundation.org
Subject: [folded] writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch removed from -mm tree
Date: Tue, 18 Jan 2011 14:04:12 -0800
Message-ID: <201101182204.p0IM4CgU008043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644Ab1ARWEj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 17:04:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hch@lst.de, jack@suse.cz, jengelh@medozas.de, mm-commits@vger.kernel.org


The patch titled
     writeback-check-skipped-pages-on-wb_sync_all-update-fix
has been removed from the -mm tree.  Its filename was
     writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch

This patch was dropped because it was folded into writeback-check-skipped-pages-on-wb_sync_all.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback-check-skipped-pages-on-wb_sync_all-update-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Christoph Hellwig <hch@lst.de> 
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~writeback-check-skipped-pages-on-wb_sync_all-update-fix fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-check-skipped-pages-on-wb_sync_all-update-fix
+++ a/fs/fs-writeback.c
@@ -530,7 +530,7 @@ static int writeback_sb_inodes(struct su
 			/*
 			 * There's no logic to retry skipped pages for sync(),
 			 * filesystems are assumed not to skip dirty pages on
-			 * temporal lock contentions or non fatal errors.
+			 * temporary lock contentions or non fatal errors.
 			 */
 			WARN_ON_ONCE(wbc->sync_mode == WB_SYNC_ALL);
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-deactivate-invalidated-pages.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

