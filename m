From: akpm@osdl.org
Subject: - mtd-esb2rom-uses-pci.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:03 -0800
Message-ID: <200612130656.kBD6u3lR030688@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57921 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965044AbWLMG4S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     MTD: ESB2ROM uses PCI
has been removed from the -mm tree.  Its filename was
     mtd-esb2rom-uses-pci.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MTD: ESB2ROM uses PCI
From: Randy Dunlap <randy.dunlap@oracle.com>

ESB2ROM uses PCI interface functions.

With CONFIG_PCI=n:
drivers/mtd/maps/esb2rom.c: In function 'esb2rom_init_one':
drivers/mtd/maps/esb2rom.c:167: warning: implicit declaration of function 'pci_dev_get'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mtd/maps/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/maps/Kconfig~mtd-esb2rom-uses-pci drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig~mtd-esb2rom-uses-pci
+++ a/drivers/mtd/maps/Kconfig
@@ -186,7 +186,7 @@ config MTD_ICHXROM
 
 config MTD_ESB2ROM
         tristate "BIOS flash chip on Intel ESB Controller Hub 2"
-        depends on X86 && MTD_JEDECPROBE
+        depends on X86 && MTD_JEDECPROBE && PCI
         help
           Support for treating the BIOS flash chip on ESB2 motherboards
           as an MTD device - with this you can reprogram your BIOS.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
fix-section-mismatch-in-parainstructions.patch
kconfig-new-function-bool-conf_get_changedvoid.patch
kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only.patch
kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc.patch
kconfig-set-gconfs-save-widgets-sensitivity-according-to-configs-changed-state.patch
isicom-fix-build-with-pci-disabled.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
kbuild-make-fusion-mpt-selectable-from-device-drivers.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

