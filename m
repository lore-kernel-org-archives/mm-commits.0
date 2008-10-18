From: akpm@linux-foundation.org
Subject: - message-queues-increase-range-limits-checkpatch-fixes.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:53:40 -0700
Message-ID: <200810182353.m9INreFk002126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899AbYJRXyr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:54:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Nadia.Derbey@bull.net, joe.korty@ccur.com, manfred@colorfullife.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     message-queues-increase-range-limits-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     message-queues-increase-range-limits-checkpatch-fixes.patch

This patch was dropped because it was folded into message-queues-increase-range-limits.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: message-queues-increase-range-limits-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: Macros with complex values should be enclosed in parenthesis
#55: FILE: ipc/mqueue.c:62:
+#define MAX_MSGSIZEMAX	8192*128	/* max value for msgsize_max */

total: 1 errors, 0 warnings, 39 lines checked

./patches/message-queues-increase-range-limits.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joe Korty <joe.korty@ccur.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/mqueue.c~message-queues-increase-range-limits-checkpatch-fixes ipc/mqueue.c
--- a/ipc/mqueue.c~message-queues-increase-range-limits-checkpatch-fixes
+++ a/ipc/mqueue.c
@@ -59,7 +59,7 @@
 #define MIN_MSGMAX	1		/* min value for msg_max */
 #define MAX_MSGMAX	HARD_MSGMAX	/* max value for msg_max */
 #define MIN_MSGSIZEMAX	128		/* min value for msgsize_max */
-#define MAX_MSGSIZEMAX	8192*128	/* max value for msgsize_max */
+#define MAX_MSGSIZEMAX	(8192*128)	/* max value for msgsize_max */
 
 struct ext_wait_queue {		/* queue of sleeping tasks */
 	struct task_struct *task;
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
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

