From: akpm@linux-foundation.org
Subject: + pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch added to -mm tree
Date: Wed, 11 Feb 2009 16:23:00 -0800
Message-ID: <200902120023.n1C0N02j016783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960AbZBLAXF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 19:23:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jbarnes@virtuousgeek.org, mirq-linux@rere.qmqm.pl, norsk5@yahoo.com


The patch titled
     pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch

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
Subject: pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#52: FILE: drivers/pci/quirks.c:1940:
+                        quirk_unhide_mch_dev6);$

ERROR: code indent should use tabs where possible
#54: FILE: drivers/pci/quirks.c:1942:
+                        quirk_unhide_mch_dev6);$

total: 2 errors, 0 warnings, 28 lines checked

./patches/pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pci/quirks.c~pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes
+++ a/drivers/pci/quirks.c
@@ -1937,9 +1937,9 @@ static void __devinit quirk_unhide_mch_d
 }
 
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82865_HB,
-                        quirk_unhide_mch_dev6);
+			quirk_unhide_mch_dev6);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82875_HB,
-                        quirk_unhide_mch_dev6);
+			quirk_unhide_mch_dev6);
 
 
 #ifdef CONFIG_PCI_MSI
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes.patch
writeback-fix-break-condition.patch
vmalloc-add-__get_vm_area_caller-checkpatch-fixes.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix.patch
seq_file-properly-cope-with-pread-fix.patch
i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
mtd-rbtx4939-add-mtd-support.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
pci-constify-pci_bus_assign_resources.patch
pci-constify-pci_bus_add_devices.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch
cciss-pci-power-management-reset-for-kexec.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-simple_set_mnt-should-return-void.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
timerfd-add-flags-check-fix.patch
lis3lv02d-support-both-one-and-two-byte-sensors-checkpatch-fixes.patch
aty128fb-properly-save-pci-state-before-changing-pci-pm-level-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
8250-fix-boot-hang-with-serial-console-when-using-with-serial-over-lan-port.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-uninline-lock_fb_info.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch
work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
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

