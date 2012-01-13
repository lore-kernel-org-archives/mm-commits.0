From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 12 Jan 2012 17:23:35 -0800
Message-ID: <20120113012335.A619F10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:34939 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab2AMBXg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 20:23:36 -0500
Received: by ggnk3 with SMTP id k3so276222ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 17:23:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig   |    4 +---
 fs/9p/vfs_inode_dotl.c |    5 -----
 fs/ext4/ioctl.c        |    4 ----
 fs/nfs/client.c        |    4 ----
 4 files changed, 1 insertion(+), 16 deletions(-)

diff -puN drivers/leds/Kconfig~linux-next-git-rejects drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~linux-next-git-rejects
+++ a/drivers/leds/Kconfig
@@ -388,7 +388,6 @@ config LEDS_RENESAS_TPU
 	  pin function. The latter to support brightness control.
 	  Brightness control is supported but hardware blinking is not.
 
-<<<<<<< HEAD
 config LEDS_TCA6507
 	tristate "LED Support for TCA6507 I2C chip"
 	depends on LEDS_CLASS && I2C
@@ -396,14 +395,13 @@ config LEDS_TCA6507
 	  This option enables support for LEDs connected to TC6507
 	  LED driver chips accessed via the I2C bus.
 	  Driver support brightness control and hardware-assisted blinking.
-=======
+
 config LEDS_MAX8997
 	tristate "LED support for MAX8997 PMIC"
 	depends on LEDS_CLASS && MFD_MAX8997
 	help
 	  This option enables support for on-chip LED drivers on
 	  MAXIM MAX8997 PMIC.
->>>>>>> linux-next/akpm-end
 
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
diff -puN fs/9p/vfs_inode_dotl.c~linux-next-git-rejects fs/9p/vfs_inode_dotl.c
--- a/fs/9p/vfs_inode_dotl.c~linux-next-git-rejects
+++ a/fs/9p/vfs_inode_dotl.c
@@ -283,13 +283,8 @@ v9fs_vfs_create_dotl(struct inode *dir, 
 	}
 
 	name = (char *) dentry->d_name.name;
-<<<<<<< HEAD
-	p9_debug(P9_DEBUG_VFS, "name:%s flags:0x%x mode:0x%hx\n",
-		 name, flags, omode);
-=======
 	p9_debug(P9_DEBUG_VFS, "v9fs_vfs_create_dotl: name:%s flags:0x%x "
 			"mode:0x%hx\n", name, flags, omode);
->>>>>>> linux-next/akpm-end
 
 	dfid = v9fs_fid_lookup(dentry->d_parent);
 	if (IS_ERR(dfid)) {
diff -puN fs/ext4/ioctl.c~linux-next-git-rejects fs/ext4/ioctl.c
--- a/fs/ext4/ioctl.c~linux-next-git-rejects
+++ a/fs/ext4/ioctl.c
@@ -257,10 +257,6 @@ group_extend_out:
 		err = ext4_move_extents(filp, donor_filp, me.orig_start,
 					me.donor_start, me.len, &me.moved_len);
 		mnt_drop_write_file(filp);
-<<<<<<< HEAD
-		mnt_drop_write(filp->f_path.mnt);
-=======
->>>>>>> linux-next/akpm-end
 
 		if (copy_to_user((struct move_extent __user *)arg,
 				 &me, sizeof(me)))
diff -puN fs/nfs/client.c~linux-next-git-rejects fs/nfs/client.c
--- a/fs/nfs/client.c~linux-next-git-rejects
+++ a/fs/nfs/client.c
@@ -84,11 +84,7 @@ retry:
 /*
  * Turn off NFSv4 uid/gid mapping when using AUTH_SYS
  */
-<<<<<<< HEAD
-static int nfs4_disable_idmapping = 1;
-=======
 static bool nfs4_disable_idmapping = 1;
->>>>>>> linux-next/akpm-end
 
 /*
  * RPC cruft for NFS
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
drivers-video-nvidia-nvidiac-fix-warning.patch
pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-simplify-lru-handling-by-new-rule.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops.patch
drivers-parport-parport_pcc-fix-warnings.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-nfs-nfs4procc-fix-printk-warnings.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

