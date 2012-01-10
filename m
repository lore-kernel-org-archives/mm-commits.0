From: akpm@linux-foundation.org
Subject: [folded] procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:56:57 -0800
Message-ID: <20120110225658.51B3A5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:50562 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2AJW5A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:57:00 -0500
Received: by werf1 with SMTP id f1so3622wer.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:56:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, segooon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-add-hidepid=-and-gid=-mount-options-fix-2
has been removed from the -mm tree.  Its filename was
     procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch

This patch was dropped because it was folded into procfs-add-hidepid=-and-gid=-mount-options.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-add-hidepid=-and-gid=-mount-options-fix-2

Cc: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/inode.c~procfs-add-hidepid=-and-gid=-mount-options-fix-2 fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-add-hidepid=-and-gid=-mount-options-fix-2
+++ a/fs/proc/inode.c
@@ -108,7 +108,7 @@ void __init proc_init_inodecache(void)
 
 static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
-	struct super_block *sb = vfs->mnt_sb;
+	struct super_block *sb = root->d_sb;
 	struct pid_namespace *pid = sb->s_fs_info;
 
 	if (pid->pid_gid)
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
procfs-add-hidepid=-and-gid=-mount-options.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch

