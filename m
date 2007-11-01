From: akpm@linux-foundation.org
Subject: + feature-removal-schedule-remove-sa_-flags-entry.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:28:17 -0700
Message-ID: <200711010728.lA17SHPB018208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55306 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353AbXKAH2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:28:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, tglx@linutronix.de


The patch titled
     feature-removal-schedule: remove SA_* flags entry
has been added to the -mm tree.  Its filename is
     feature-removal-schedule-remove-sa_-flags-entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: feature-removal-schedule: remove SA_* flags entry
From: Adrian Bunk <bunk@kernel.org>

No reason to keep the feature-removal-schedule.txt entry after the code
was removed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~feature-removal-schedule-remove-sa_-flags-entry Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~feature-removal-schedule-remove-sa_-flags-entry
+++ a/Documentation/feature-removal-schedule.txt
@@ -164,15 +164,6 @@ Who:	Nick Piggin <npiggin@suse.de>
 
 ---------------------------
 
-What:	Interrupt only SA_* flags
-When:	September 2007
-Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
-	out of the signal namespace.
-
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
----------------------------
-
 What:	PHYSDEVPATH, PHYSDEVBUS, PHYSDEVDRIVER in the uevent environment
 When:	October 2008
 Why:	The stacking of class devices makes these values misleading and
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
scsi-advansysc-make-3-functions-static.patch
git-block.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
fs-ecryptfs-possible-cleanups.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
