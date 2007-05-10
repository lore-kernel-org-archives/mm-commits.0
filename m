From: akpm@linux-foundation.org
Subject: + submitchecklist-add-W-help.patch added to -mm tree
Date: Thu, 10 May 2007 16:55:11 -0700
Message-ID: <200705102355.l4ANtBUe001787@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754891AbXEJXzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 19:55:14 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l4ANtCw4009394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 10 May 2007 16:55:13 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     SubmitChecklist: add -W help
has been added to the -mm tree.  Its filename is
     submitchecklist-add-W-help.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SubmitChecklist: add -W help
From: Andrew Morton <akpm@linux-foundation.org>

Help people to work out how to use `gcc -W'.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/SubmitChecklist~submitchecklist-add-W-help Documentation/SubmitChecklist
--- a/Documentation/SubmitChecklist~submitchecklist-add-W-help
+++ a/Documentation/SubmitChecklist
@@ -73,9 +73,9 @@ kernel patches.
     If the new code is substantial, addition of subsystem-specific fault
     injection might be appropriate.
 
-22: Newly-added code has been compiled with `gcc -W'.  This will generate
-    lots of noise, but is good for finding bugs like "warning: comparison
-    between signed and unsigned".
+22: Newly-added code has been compiled with `gcc -W' (use "make
+    EXTRA_CFLAGS=-W").  This will generate lots of noise, but is good for
+    finding bugs like "warning: comparison between signed and unsigned".
 
 23: Tested after it has been merged into the -mm patchset to make sure
     that it still works with all of the other queued patches and various
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-fix.patch
git-hid-fixup.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-leds.patch
git-leds-fixup.patch
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
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
lib-hexdump.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
synclink_gt-add-compat_ioctl-fix.patch
stop_machine-now-uses-hard_irq_disable-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
submitchecklist-add-W-help.patch
tty-add-compat_ioctl.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
use-defines-in-sys_getpriority-sys_setpriority-fix.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
ntfs-use-zero_user_page.patch
pm3fb-preliminary-24-to-26-port-fix.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
