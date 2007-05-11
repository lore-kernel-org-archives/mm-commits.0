From: akpm@linux-foundation.org
Subject: + add-common-orderly_poweroff-fix.patch added to -mm tree
Date: Fri, 11 May 2007 16:17:58 -0700
Message-ID: <200705112317.l4BNHwh2029197@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755043AbXEKXSj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 19:18:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jeremy@goop.org, randy.dunlap@oracle.com


The patch titled
     add-common-orderly_poweroff-fix
has been added to the -mm tree.  Its filename is
     add-common-orderly_poweroff-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-common-orderly_poweroff-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 sysctl.c     |    0 
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sparc64/kernel/power.c~add-common-orderly_poweroff-fix arch/sparc64/kernel/power.c
diff -puN drivers/acpi/thermal.c~add-common-orderly_poweroff-fix drivers/acpi/thermal.c
diff -puN drivers/sbus/char/bbc_envctrl.c~add-common-orderly_poweroff-fix drivers/sbus/char/bbc_envctrl.c
diff -puN drivers/sbus/char/envctrl.c~add-common-orderly_poweroff-fix drivers/sbus/char/envctrl.c
diff -puN include/linux/reboot.h~add-common-orderly_poweroff-fix include/linux/reboot.h
diff -puN include/linux/sysctl.h~add-common-orderly_poweroff-fix include/linux/sysctl.h
diff -puN kernel/sys.c~add-common-orderly_poweroff-fix kernel/sys.c
--- a/kernel/sys.c~add-common-orderly_poweroff-fix
+++ a/kernel/sys.c
@@ -2286,7 +2286,7 @@ static void argv_cleanup(char **argv, ch
 }
 
 /**
- * Trigger an orderly system poweroff
+ * orderly_poweroff - Trigger an orderly system poweroff
  * @force: force poweroff if command execution fails
  *
  * This may be called from any context to trigger a system shutdown.
diff -puN kernel/sysctl.c~add-common-orderly_poweroff-fix kernel/sysctl.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-hexdump.patch
stop_machine-now-uses-hard_irq_disable.patch
submitchecklist-add-W-help.patch
tty-add-compat_ioctl.patch
use-defines-in-sys_getpriority-sys_setpriority.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
pm3fb-preliminary-24-to-26-port.patch
ntfs-use-zero_user_page.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
arm-stacktrace-fix.patch
git-avr32.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
git-hid-fixup.patch
sn-validate-smp_affinity-mask-on-intr-redirect.patch
git-leds.patch
git-leds-fixup.patch
git-libata-all-sata_via-build-fix.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
netxen_nic_main-dont-use-deprecated-irq-flags.patch
mlx4-dont-use-deprecated-irq-flags.patch
fix-race-condition-about-network-device-name-fix.patch
git-battery.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
git-wireless-fixup.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
xfs-clean-up-shrinker-games.patch
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
add-common-orderly_poweroff-fix.patch
crc7-support-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
check_dirty_inode_list.patch
