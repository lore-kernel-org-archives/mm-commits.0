From: akpm@linux-foundation.org
Subject: + xtensa-add-flat-support-checkpatch-fixes.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:07:29 -0800
Message-ID: <200903052207.n25M7TrJ006540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbZCEWHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:07:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, chris@zankel.net, jw@emlix.com, os@emlix.com


The patch titled
     xtensa-add-flat-support-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     xtensa-add-flat-support-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
git-acpi-vs-git-cpufreq.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
kernel-auditscc-fix-warning.patch
early-platform-driver-v3.patch
sysfs-dont-block-indefinitely-for-unmapped-files.patch
drivers-gpu-drm-drm_infoc-fix-warnings.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
mmc-add-extended-csd-register-to-debugfs.patch
mtd-rbtx4939-add-mtd-support.patch
mtd-flex-onenand-support-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-simple_set_mnt-should-return-void.patch
libfs-make-simple_read_from_buffer-conventional-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
mtd_dataflash-fix-probing-of-at45db321c-chips-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
ia64-fix-pci-dma-flag-propagation-on-sn-altix-with-pics.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
alpha-convert-u64-to-unsigned-long-long-fix-3-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
ubd-stop-defintining-major_nr-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
flat-fix-data-sections-alignment-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios-fix.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
cirrusfb-fix-clock-doubling-fix.patch
fbdev-uninline-lock_fb_info.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
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

