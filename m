From: akpm@linux-foundation.org
Subject: [withdrawn] xtensa-add-flat-support-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 16 Apr 2009 01:24:56 -0700
Message-ID: <200904160824.n3G8OuJu003870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbZDPI2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 04:28:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@zankel.net, jw@emlix.com, os@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa-add-flat-support-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     xtensa-add-flat-support-checkpatch-fixes.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa-add-flat-support-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space prohibited before that close parenthesis ')'
#26: FILE: arch/xtensa/include/asm/flat.h:8:
+#define flat_put_addr_at_rp(rp, val, relval	)	put_unaligned(val, rp)

total: 1 errors, 0 warnings, 12 lines checked

./patches/xtensa-add-flat-support.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Chris Zankel <chris@zankel.net>
Cc: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/flat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/xtensa/include/asm/flat.h~xtensa-add-flat-support-checkpatch-fixes arch/xtensa/include/asm/flat.h
--- a/arch/xtensa/include/asm/flat.h~xtensa-add-flat-support-checkpatch-fixes
+++ a/arch/xtensa/include/asm/flat.h
@@ -5,7 +5,7 @@
 #define flat_old_ram_flag(flags)			(flags)
 #define flat_reloc_valid(reloc, size)			((reloc) <= (size))
 #define flat_get_addr_from_rp(rp, relval, flags, p)	get_unaligned(rp)
-#define flat_put_addr_at_rp(rp, val, relval	)	put_unaligned(val, rp)
+#define flat_put_addr_at_rp(rp, val, relval)		put_unaligned(val, rp)
 #define flat_get_relocate_addr(rel)			(rel)
 #define flat_set_persistent(relval, p)			0
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch
clocksource-pass-clocksource-to-read-callback.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

