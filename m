From: akpm@linux-foundation.org
Subject: - vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:34:21 -0700
Message-ID: <200810182334.m9INYLjX031781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbYJRXeh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:34:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch

This patch was dropped because it was folded into vmscan-fix-pagecache-reclaim-referenced-bit-check.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix
+++ a/mm/vmscan.c
@@ -1103,12 +1103,6 @@ static void shrink_active_list(unsigned 
 	}
 
 	/*
-	 * Count the referenced pages as rotated, even when they are moved
-	 * to the inactive list.  This helps balance scan pressure between
-	 * file and anonymous pages in get_scan_ratio.
- 	 */
-
-	/*
 	 * Count referenced pages from currently used mappings as
 	 * rotated, even though they are moved to the inactive list.
 	 * This helps balance scan pressure between file and anonymous
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

