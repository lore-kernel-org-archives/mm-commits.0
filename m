From: akpm@osdl.org
Subject: + readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb.patch added to -mm tree
Date: Mon, 29 Jan 2007 15:30:11 -0800
Message-ID: <200701292330.l0TNUBMW002524@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33580 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964934AbXA2XaP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 18:30:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: initial method: user recommended size: rename to read_ahead_initial_kb
has been added to the -mm tree.  Its filename is
     readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: initial method: user recommended size: rename to read_ahead_initial_kb
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Rename the sysfs parameter initial_ra_kb to read_ahead_initial_kb, which
hopefully is a more consistent and user friendly name.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 block/ll_rw_blk.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN block/ll_rw_blk.c~readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb
+++ a/block/ll_rw_blk.c
@@ -3993,7 +3993,7 @@ static struct queue_sysfs_entry queue_ra
 };
 
 static struct queue_sysfs_entry queue_initial_ra_entry = {
-	.attr = {.name = "initial_ra_kb", .mode = S_IRUGO | S_IWUSR },
+	.attr = {.name = "read_ahead_initial_kb", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_initial_ra_show,
 	.store = queue_initial_ra_store,
 };
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-kconfig-options.patch
readahead-kconfig-options-fix.patch
radixtree-introduce-scan-hole-data-functions.patch
mm-introduce-probe_page.patch
mm-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-insert-cond_resched-calls.patch
readahead-minmax_ra_pages.patch
readahead-events-accounting.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
readahead-rescue_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-sysctl-parameters-fix.patch
readahead-sysctl-parameters-set-readahead_hit_rate=1.patch
readahead-min-max-sizes.patch
readahead-min-max-sizes-remove-get_readahead_bounds.patch
readahead-min-max-sizes-increase-vm_min_readahead-to-32kb.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method-routines-explicitly-embed-class_new-class_old-inside-flags.patch
readahead-state-based-method.patch
readahead-state-based-method-prevent-tiny-size.patch
readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold.patch
readahead-context-based-method.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-context-based-method-update-ra_min.patch
readahead-context-based-method-remove-readahead_ratio.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-fix.patch
readahead-call-scheme.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-call-scheme-remove-get_readahead_bounds.patch
readahead-call-scheme-fix-thrashed-unaligned-read.patch
readahead-laptop-mode.patch
readahead-laptop-mode-fix.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
readahead-nfsd-case-fix-uninitialized-ra_min-ra_max.patch
readahead-nfsd-case-remove-ra_min.patch
readahead-turn-on-by-default.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
