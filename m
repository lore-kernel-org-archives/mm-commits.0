From: akpm@linux-foundation.org
Subject: + x86_64-extract-helper-function-from-e820_register_active_regions-fix.patch added to -mm tree
Date: Wed, 09 May 2007 16:13:24 -0700
Message-ID: <200705092313.l49NDOXa005311@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757315AbXEIXNf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 19:13:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, mel@csn.ul.ie, rientjes@google.com


The patch titled
     x86_64-extract-helper-function-from-e820_register_active_regions-fix
has been added to the -mm tree.  Its filename is
     x86_64-extract-helper-function-from-e820_register_active_regions-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64-extract-helper-function-from-e820_register_active_regions-fix
From: Andrew Morton <akpm@linux-foundation.org>

We usually put the storage thingy after the type.

Cc: Andi Kleen <ak@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/e820.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/e820.c~x86_64-extract-helper-function-from-e820_register_active_regions-fix arch/x86_64/kernel/e820.c
--- a/arch/x86_64/kernel/e820.c~x86_64-extract-helper-function-from-e820_register_active_regions-fix
+++ a/arch/x86_64/kernel/e820.c
@@ -293,7 +293,7 @@ void __init e820_mark_nosave_regions(voi
  * Finds an active region in the address range from start_pfn to end_pfn and
  * returns its range in ei_startpfn and ei_endpfn for the e820 entry.
  */
-static __init int e820_find_active_region(const struct e820entry *ei,
+static int __init e820_find_active_region(const struct e820entry *ei,
 					  unsigned long start_pfn,
 					  unsigned long end_pfn,
 					  unsigned long *ei_startpfn,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
x86_64-rename-and-export-bad_srat-to-kernel-code-fix.patch
x86_64-extract-helper-function-from-e820_register_active_regions-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
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
