From: akpm@linux-foundation.org
Subject: - x86-sysfs-kill-owner-field-from-attribute-fix.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:54:14 -0700
Message-ID: <200810182354.m9INsEOB002194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957AbYJRXzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:55:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, david-b@pacbell.net, greg@kroah.com, htejun@gmail.com, jens.axboe@oracle.com, khali@linux-fr.org, lenb@kernel.org, mingo@elte.hu, para


The patch titled
     x86-sysfs-kill-owner-field-from-attribute-fix
has been removed from the -mm tree.  Its filename was
     x86-sysfs-kill-owner-field-from-attribute-fix.patch

This patch was dropped because it was folded into x86-sysfs-kill-owner-field-from-attribute.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-sysfs-kill-owner-field-from-attribute-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Parag Warudkar" <parag.lkml@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysfs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/sysfs.h~x86-sysfs-kill-owner-field-from-attribute-fix include/linux/sysfs.h
--- a/include/linux/sysfs.h~x86-sysfs-kill-owner-field-from-attribute-fix
+++ a/include/linux/sysfs.h
@@ -27,7 +27,7 @@ struct module;
  */
 struct attribute {
 	const char		*name;
-#if !defined(CONFIG_X86_64) && !defined(CONFIG_X86_32)
+#ifndef CONFIG_X86
 	struct module		*owner;
 #endif
 	mode_t			mode;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct.patch
mm-rewrite-vmap-layer.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-implement-freezer-cgroup-subsystem.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
fb-push-down-the-bkl-in-the-ioctl-handler.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
message-queues-increase-range-limits.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

