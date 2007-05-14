From: akpm@linux-foundation.org
Subject: + 8xx-mpc885ads-pcmcia-support-fix.patch added to -mm tree
Date: Mon, 14 May 2007 14:27:40 -0700
Message-ID: <200705142127.l4ELRexi026635@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754737AbXENV2I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 17:28:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arnd@arndb.de, benh@kernel.crashing.org, galak@gate.crashing.org, linux@dominikbrodowski.net, olof@lixom.net, paulus@samba.org, vitb@kernel.crashing.org


The patch titled
     8xx-mpc885ads-pcmcia-support-fix
has been added to the -mm tree.  Its filename is
     8xx-mpc885ads-pcmcia-support-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 8xx-mpc885ads-pcmcia-support-fix
From: Andrew Morton <akpm@linux-foundation.org>

whitespace diddles

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/mpc8xx_pic.h |    3 ++-
 drivers/pcmcia/Kconfig           |   14 +++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN arch/powerpc/sysdev/mpc8xx_pic.h~8xx-mpc885ads-pcmcia-support-fix arch/powerpc/sysdev/mpc8xx_pic.h
--- a/arch/powerpc/sysdev/mpc8xx_pic.h~8xx-mpc885ads-pcmcia-support-fix
+++ a/arch/powerpc/sysdev/mpc8xx_pic.h
@@ -11,7 +11,8 @@ unsigned int mpc8xx_get_irq(void);
  * Some internal interrupt registers use an 8-bit mask for the interrupt
  * level instead of a number.
  */
-static inline uint mk_int_int_mask(uint mask) {
+static inline uint mk_int_int_mask(uint mask)
+{
 	return (1 << (7 - (mask/2)));
 }
 
diff -puN drivers/pcmcia/Kconfig~8xx-mpc885ads-pcmcia-support-fix drivers/pcmcia/Kconfig
--- a/drivers/pcmcia/Kconfig~8xx-mpc885ads-pcmcia-support-fix
+++ a/drivers/pcmcia/Kconfig
@@ -180,15 +180,15 @@ config TCIC
 	  PCMCIA cards are plugged into. If unsure, say N.
 
 config PCMCIA_M8XX
-        tristate "MPC8xx PCMCIA support"
-        depends on PCMCIA && PPC && 8xx 
-        select PCCARD_IODYN
+	tristate "MPC8xx PCMCIA support"
+	depends on PCMCIA && PPC && 8xx
+	select PCCARD_IODYN
 	select PCCARD_NONSTATIC
-        help
-        Say Y here to include support for PowerPC 8xx series PCMCIA
-        controller.
+	help
+	  Say Y here to include support for PowerPC 8xx series PCMCIA
+	  controller.
 
-        This driver is also available as a module called m8xx_pcmcia.
+	  This driver is also available as a module called m8xx_pcmcia.
 
 config HD64465_PCMCIA
 	tristate "HD64465 host bridge support"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
8xx-mpc885ads-pcmcia-support-fix.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
git-gfs2-nmw.patch
git-hid-fixup.patch
git-ieee1394.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mips-fixup.patch
git-ubi.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-ocfs2.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
git-newsetup-fixup.patch
xfs-clean-up-shrinker-games.patch
remove-slab_ctor_constructor-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
crc7-support-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
tglx-debug.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
git-gccbug-fixup.patch
w1-build-fix.patch
check_dirty_inode_list.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
x86_64-fix-smp_call_function_single-return-value.patch
