From: akpm@linux-foundation.org
Subject: - git-dvb-fixup.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:10 -0700
Message-ID: <200705090257.l492vAsG010146@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032752AbXEIC5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:13 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l492vAUb022664
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 8 May 2007 19:57:11 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-dvb-fixup
has been removed from the -mm tree.  Its filename was
     git-dvb-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-dvb-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx88/cx88-alsa.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/media/video/cx88/cx88-alsa.c~git-dvb-fixup drivers/media/video/cx88/cx88-alsa.c
--- a/drivers/media/video/cx88/cx88-alsa.c~git-dvb-fixup
+++ a/drivers/media/video/cx88/cx88-alsa.c
@@ -27,12 +27,8 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
-<<<<<<< HEAD/drivers/media/video/cx88/cx88-alsa.c
 #include <linux/dma-mapping.h>
 
-=======
-#include <linux/dma-mapping.h>
->>>>>>> /drivers/media/video/cx88/cx88-alsa.c
 #include <asm/delay.h>
 #include <sound/driver.h>
 #include <sound/core.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
git-hid-fixup.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-kvm.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mtd.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-battery-fix.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
swsusp-clean-up-print.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
upper-32-bits.patch
lib-hexdump-fix.patch
pasemi-hardware-rng-driver-tidy.patch
nbd-check-the-return-value-of-sysfs_create_file-fix.patch
mutex_lock_interruptible-add-__must_check.patch
mutex_lock_interruptible-add-__must_check-must-fix.patch
tty-add-compat_ioctl-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
make-vm-statistics-update-interval-configurable-fix.patch
rename-thread_info-to-stack-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
