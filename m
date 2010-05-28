From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 28 May 2010 11:48:29 -0700
Message-ID: <201005281848.o4SImRqX006383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121Ab0E1Ssa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 14:48:30 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o4SImSLs001361
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 28 May 2010 11:48:29 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/logfs/logfs.h |    6 ------
 fs/ufs/file.c    |    5 -----
 2 files changed, 11 deletions(-)

diff -puN fs/logfs/logfs.h~linux-next-git-rejects fs/logfs/logfs.h
--- a/fs/logfs/logfs.h~linux-next-git-rejects
+++ a/fs/logfs/logfs.h
@@ -504,15 +504,9 @@ extern const struct inode_operations log
 extern const struct file_operations logfs_reg_fops;
 extern const struct address_space_operations logfs_reg_aops;
 int logfs_readpage(struct file *file, struct page *page);
-<<<<<<< HEAD
-int logfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		unsigned long arg);
-int logfs_fsync(struct file *file, int datasync);
-=======
 long logfs_ioctl(struct file *file, unsigned int cmd,
 		 unsigned long arg);
 int logfs_fsync(struct file *file, struct dentry *dentry, int datasync);
->>>>>>> FETCH_HEAD
 
 /* gc.c */
 u32 get_best_cand(struct super_block *sb, struct candidate_list *list, u32 *ec);
diff -puN fs/ufs/file.c~linux-next-git-rejects fs/ufs/file.c
--- a/fs/ufs/file.c~linux-next-git-rejects
+++ a/fs/ufs/file.c
@@ -40,12 +40,7 @@ const struct file_operations ufs_file_op
 	.write		= do_sync_write,
 	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
-<<<<<<< HEAD
 	.open           = dquot_file_open,
-	.fsync		= generic_file_fsync,
-=======
-	.open           = generic_file_open,
 	.fsync		= simple_fsync,
->>>>>>> FETCH_HEAD
 	.splice_read	= generic_file_splice_read,
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
lib-kobject_ueventc-fix-conig_net=n-warning.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
fix-stop_machine-reimplement-using-cpu_stop.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

