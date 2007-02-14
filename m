From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch removed from -mm tree
Date: Tue, 13 Feb 2007 22:57:11 -0800
Message-ID: <200702140657.l1E6vBFM023793@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43936 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbXBNG5N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 01:57:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix-2
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch

This patch was dropped because it was folded into sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch

------------------------------------------------------
Subject: sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix-2
From: Andrew Morton <akpm@osdl.org>

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ntfs/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ntfs/sysctl.c~sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix fs/ntfs/sysctl.c
--- a/fs/ntfs/sysctl.c~sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix
+++ a/fs/ntfs/sysctl.c
@@ -36,7 +36,7 @@
 /* Definition of the ntfs sysctl. */
 static ctl_table ntfs_sysctls[] = {
 	{
-		.ctl_name	= CTL_UNUMBERED,	/* Binary and text IDs. */
+		.ctl_name	= CTL_UNNUMBERED,	/* Binary and text IDs. */
 		.procname	= "ntfs-debug",
 		.data		= &debug_msgs,		/* Data pointer and size. */
 		.maxlen		= sizeof(debug_msgs),
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
