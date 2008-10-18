From: akpm@linux-foundation.org
Subject: - container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:40:53 -0700
Message-ID: <200810182340.m9INerhG032735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbYJRXlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:41:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clg@fr.ibm.com, matthltc@us.ibm.com, nigel@tuxonice.net, pavel@suse.cz, rjw@sisk.pl, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     container-freezer-add-tif_freeze-flag-to-all-architectures-fix
has been removed from the -mm tree.  Its filename was
     container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch

This patch was dropped because it was folded into container-freezer-add-tif_freeze-flag-to-all-architectures.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: container-freezer-add-tif_freeze-flag-to-all-architectures-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/thread_info_32.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sparc/include/asm/thread_info_32.h~container-freezer-add-tif_freeze-flag-to-all-architectures-fix arch/sparc/include/asm/thread_info_32.h
--- a/arch/sparc/include/asm/thread_info_32.h~container-freezer-add-tif_freeze-flag-to-all-architectures-fix
+++ a/arch/sparc/include/asm/thread_info_32.h
@@ -149,7 +149,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
 #define _TIF_DO_NOTIFY_RESUME_MASK	(_TIF_NOTIFY_RESUME | \
 					 _TIF_SIGPENDING | \
 					 _TIF_RESTORE_SIGMASK)
-#define TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #endif /* __KERNEL__ */
 
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

