From: akpm@linux-foundation.org
Subject: + make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch added to -mm tree
Date: Thu, 03 May 2007 22:25:14 -0700
Message-ID: <200705040525.l445PEZW029748@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161485AbXEDFZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 01:25:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, ak@suse.de


The patch titled
     make arch/i386/kernel/setup.c:remapped_pgdat_init() static
has been added to the -mm tree.  Its filename is
     make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make arch/i386/kernel/setup.c:remapped_pgdat_init() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/setup.c~make-arch-i386-kernel-setupcremapped_pgdat_init-static arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c~make-arch-i386-kernel-setupcremapped_pgdat_init-static
+++ a/arch/i386/kernel/setup.c
@@ -475,7 +475,7 @@ void __init setup_bootmem_allocator(void
  *
  * This should all compile down to nothing when NUMA is off.
  */
-void __init remapped_pgdat_init(void)
+static void __init remapped_pgdat_init(void)
 {
 	int nid;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
git-acpi.patch
git-alsa.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
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
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-scsi-ipsc-remove-kernel-24-code.patch
drivers-scsi-nsp32c-remove-kernel-24-code.patch
git-unionfs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
apple-smc-driver-hardware-monitoring-and-control-cleanup.patch
the-scheduled-removal-of-obsolete_oss-options.patch
add-file-position-info-to-proc.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
unexport-pci_proc_attach_device.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
ext2-reservations.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
rtc-remove-sys-class-rtc-dev-fix.patch
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
drivers-video-sis-remove-more-kernel-24-code.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
