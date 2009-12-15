From: akpm@linux-foundation.org
Subject: [folded] hwmon-w83627ehf-updates-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:12:34 -0800
Message-ID: <200912150112.nBF1CY0L025598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756543AbZLOBMh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:12:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.blueman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hwmon-w83627ehf-updates-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     hwmon-w83627ehf-updates-checkpatch-fixes.patch

This patch was dropped because it was folded into hwmon-w83627ehf-updates.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon-w83627ehf-updates-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#44: FILE: drivers/hwmon/w83627ehf.c:8:
+                        Daniel J Blueman <daniel.blueman@gmail.com>$

WARNING: line over 80 characters
#88: FILE: drivers/hwmon/w83627ehf.c:306:
+			     4->variable thermal cruise (also called SmartFan III) */

WARNING: line over 80 characters
#111: FILE: drivers/hwmon/w83627ehf.c:544:
+						W83627EHF_REG_FAN_START_OUTPUT[i]);

WARNING: line over 80 characters
#113: FILE: drivers/hwmon/w83627ehf.c:546:
+						W83627EHF_REG_FAN_STOP_OUTPUT[i]);

total: 1 errors, 3 warnings, 153 lines checked

./patches/hwmon-w83627ehf-updates.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/hwmon/w83627ehf~hwmon-w83627ehf-updates-checkpatch-fixes Documentation/hwmon/w83627ehf
diff -puN drivers/hwmon/w83627ehf.c~hwmon-w83627ehf-updates-checkpatch-fixes drivers/hwmon/w83627ehf.c
--- a/drivers/hwmon/w83627ehf.c~hwmon-w83627ehf-updates-checkpatch-fixes
+++ a/drivers/hwmon/w83627ehf.c
@@ -5,7 +5,7 @@
     Copyright (C) 2006  Yuan Mu (Winbond),
                         Rudolf Marek <r.marek@assembler.cz>
                         David Hubbard <david.c.hubbard@gmail.com>
-                        Daniel J Blueman <daniel.blueman@gmail.com>
+			Daniel J Blueman <daniel.blueman@gmail.com>
 
     Shamelessly ripped from the w83627hf driver
     Copyright (C) 2003  Mark Studebaker
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments.patch
rwsem-fix-rwsem_is_locked-bugs.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
errh-add-helper-function-to-simplify-pointer-error-checking.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim.patch
blackfin-sd-host-controller-driver.patch
crc32-minor-optimizations-and-cleanup.patch
hwmon-w83627ehf-updates.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

