From: akpm@linux-foundation.org
Subject: - drivers-scsi-dpt_i2oc-remove-dead-code.patch removed from -mm tree
Date: Sun, 01 Apr 2007 23:14:37 -0700
Message-ID: <200704020614.l326EbJa025934@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39909 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933253AbXDBGRv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 02:17:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/dpt_i2o.c: remove dead code
has been removed from the -mm tree.  Its filename was
     drivers-scsi-dpt_i2oc-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/dpt_i2o.c: remove dead code
From: Adrian Bunk <bunk@stusta.de>

The Coverity checker spotted this dead code introduced by
commit a07f353701acae77e023f6270e8af353b37af7c4.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dpt_i2o.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/scsi/dpt_i2o.c~drivers-scsi-dpt_i2oc-remove-dead-code drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~drivers-scsi-dpt_i2oc-remove-dead-code
+++ a/drivers/scsi/dpt_i2o.c
@@ -195,8 +195,6 @@ static int adpt_detect(struct scsi_host_
 			pci_dev_get(pDev);
 		}
 	}
-	if (pDev)
-		pci_dev_put(pDev);
 
 	/* In INIT state, Activate IOPs */
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
fix-microcode-related-suspend-problem.patch
net-sunrpc-svcsockc-fix-a-check.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
make-drivers-net-qla3xxxcphy_devices-static.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
add-file-position-info-to-proc-fix.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
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
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
