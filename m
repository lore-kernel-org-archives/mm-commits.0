From: akpm@linux-foundation.org
Subject: - add-file-position-info-to-proc-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:34:07 -0700
Message-ID: <200704301934.l3UJY8xw013020@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946728AbXD3Tew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:34:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     make struct proc_fdinfo_file_operations static
has been removed from the -mm tree.  Its filename was
     add-file-position-info-to-proc-fix.patch

This patch was dropped because it was folded into add-file-position-info-to-proc.patch

------------------------------------------------------
Subject: make struct proc_fdinfo_file_operations static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~add-file-position-info-to-proc-fix fs/proc/base.c
--- a/fs/proc/base.c~add-file-position-info-to-proc-fix
+++ a/fs/proc/base.c
@@ -1443,7 +1443,7 @@ static ssize_t proc_fdinfo_read(struct f
 	return err;
 }
 
-const struct file_operations proc_fdinfo_file_operations = {
+static const struct file_operations proc_fdinfo_file_operations = {
 	.open		= nonseekable_open,
 	.read		= proc_fdinfo_read,
 };
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-netdev-all.patch
ibmtr_cs-fix-hang-on-eject.patch
git-ocfs2.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-ipwireless_cs.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
add-file-position-info-to-proc.patch
add-file-position-info-to-proc-fix.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
unexport-pci_proc_attach_device.patch
fix-race-between-rmmod-and-cat-proc-kallsyms-fix.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
ext2-reservations.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
