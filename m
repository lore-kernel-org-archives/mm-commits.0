From: akpm@linux-foundation.org
Subject: + remove-warnings-for-longstanding-conditions-fix.patch added to -mm tree
Date: Thu, 25 Oct 2007 14:36:41 -0700
Message-ID: <200710252136.l9PLafrF025251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41215 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757959AbXJYVhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 17:37:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@steeleye.com, jeff@garzik.org, kkeil@suse.de, willy@debian.org


The patch titled
     remove-warnings-for-longstanding-conditions-fix
has been added to the -mm tree.  Its filename is
     remove-warnings-for-longstanding-conditions-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove-warnings-for-longstanding-conditions-fix
From: Andrew Morton <akpm@linux-foundation.org>

revert advansys bit as per Matthew's request.

Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/advansys.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/advansys.c~remove-warnings-for-longstanding-conditions-fix drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c~remove-warnings-for-longstanding-conditions-fix
+++ a/drivers/scsi/advansys.c
@@ -68,6 +68,7 @@
  *  7. advansys_info is not safe against multiple simultaneous callers
  *  8. Add module_param to override ISA/VLB ioport array
  */
+#warning this driver is still not properly converted to the DMA API
 
 /* Enable driver /proc statistics. */
 #define ADVANSYS_STATS
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

sunrpc-fix-rpc-debugging-checkpatch-fixes.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ata-ahci-enable-enclosure-management-via-led-checkpatch-fixes.patch
libata-pata_it821x-improve-handling-of-poorly-compatible-emulations-checkpatch-fixes.patch
ide-arm-hack.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
git-unionfs.patch
git-v9fs-fixup.patch
git-watchdog.patch
watchdog-add-nano-7240-driver-checkpatch-fixes.patch
git-wireless.patch
git-wireless-fixup.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
i386-and-x86_64-randomize-brk-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-warnings-for-longstanding-conditions-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
