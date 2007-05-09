From: akpm@linux-foundation.org
Subject: - git-battery-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 14:55:16 -0700
Message-ID: <200705092155.l49LtGVT003252@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759325AbXEIVzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cbou@mail.ru, mm-commits@vger.kernel.org


The patch titled
     git-battery-fix
has been removed from the -mm tree.  Its filename was
     git-battery-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-battery-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/bus.c~git-battery-fix drivers/base/bus.c
--- a/drivers/base/bus.c~git-battery-fix
+++ a/drivers/base/bus.c
@@ -740,7 +740,7 @@ void put_bus(struct bus_type * bus)
 
 struct bus_type * find_bus(char * name)
 {
-	struct kobject * k = kset_find_obj(&bus_subsys.kset, name);
+	struct kobject * k = kset_find_obj(&bus_subsys, name);
 	return k ? to_bus(k) : NULL;
 }
 EXPORT_SYMBOL_GPL(find_bus);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
git-acpi.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
cinergyt2-fix-file-release-handler.patch
git-hid-fixup.patch
git-ia64-sa_interrupt-is-deprecated.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-battery.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
git-wireless-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
upper-32-bits.patch
lib-hexdump.patch
tty-add-compat_ioctl.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
ntfs-use-zero_user_page.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
