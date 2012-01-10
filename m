From: akpm@linux-foundation.org
Subject: [folded] procfs-parse-mount-options-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:56:25 -0800
Message-ID: <20120110225626.2CCF7200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:37292 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2AJW42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:56:28 -0500
Received: by eekd41 with SMTP id d41so3357eek.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:56:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, segoon@openwall.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-parse-mount-options-fix
has been removed from the -mm tree.  Its filename was
     procfs-parse-mount-options-fix.patch

This patch was dropped because it was folded into procfs-parse-mount-options.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-parse-mount-options-fix

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/inode.c~procfs-parse-mount-options-fix fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-parse-mount-options-fix
+++ a/fs/proc/inode.c
@@ -106,7 +106,7 @@ void __init proc_init_inodecache(void)
 					     init_once);
 }
 
-static int proc_show_options(struct seq_file *seq, struct vfsmount *vfs)
+static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-more-intensive-memory-corruption-debug.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mempool-fix-first-round-failure-behavior.patch
backlight-convert-pwm_bl-to-dev_pm_ops.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc.patch
drivers-rtc-rtc-mxcc-make-alarm-work.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
procfs-parse-mount-options.patch
procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch

