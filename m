From: akpm@linux-foundation.org
Subject: - arch-i386-kernel-alternativec-should-include-asm-bugsh.patch removed from -mm tree
Date: Wed, 28 Mar 2007 11:40:46 -0700
Message-ID: <200703281840.l2SIemvb017256@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53761 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965657AbXC1SoF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 14:44:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     arch/i386/kernel/alternative.c should #include <asm/bugs.h>
has been removed from the -mm tree.  Its filename was
     arch-i386-kernel-alternativec-should-include-asm-bugsh.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: arch/i386/kernel/alternative.c should #include <asm/bugs.h>
From: Adrian Bunk <bunk@stusta.de>

Every file should include the headers containing the prototypes for its
global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/i386/kernel/alternative.c~arch-i386-kernel-alternativec-should-include-asm-bugsh arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~arch-i386-kernel-alternativec-should-include-asm-bugsh
+++ a/arch/i386/kernel/alternative.c
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
+#include <asm/bugs.h>
 
 static int no_replacement    = 0;
 static int smp_alt_once      = 0;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
drivers-spi-fix-section-mismatches.patch
drivers-eisa-pci_eisacpci_eisa_init-should-be-init.patch
remove-the-warn_on-in-arch-x86_64-kernel-acpi-sleepcinit_low_mapping.patch
net-sunrpc-svcsockc-fix-a-check.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
make-mptspi_target_destroy-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
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
