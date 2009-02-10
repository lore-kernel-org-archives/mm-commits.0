From: akpm@linux-foundation.org
Subject: + mm-introduce-for_each_populated_zone-macro-cleanup.patch added to -mm tree
Date: Tue, 10 Feb 2009 14:50:33 -0800
Message-ID: <200902102250.n1AMoXCp028953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbZBJWvB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 17:51:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     mm-introduce-for_each_populated_zone-macro-cleanup
has been added to the -mm tree.  Its filename is
     mm-introduce-for_each_populated_zone-macro-cleanup.patch

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
Subject: mm-introduce-for_each_populated_zone-macro-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/mmzone.h~mm-introduce-for_each_populated_zone-macro-cleanup include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-introduce-for_each_populated_zone-macro-cleanup
+++ a/include/linux/mmzone.h
@@ -814,9 +814,6 @@ extern struct zone *next_zone(struct zon
 			; /* do nothing */		\
 		else
 
-
-
-
 static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 {
 	return zoneref->zone;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix.patch
seq_file-properly-cope-with-pread-fix.patch
i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
arch-powerpc-eliminate-double-sizeof-checkpatch-fixes.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
pci-constify-pci_bus_assign_resources.patch
pci-constify-pci_bus_assign_resources-fix.patch
pci-constify-pci_bus_add_devices.patch
cciss-pci-power-management-reset-for-kexec-cleanup.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-simple_set_mnt-should-return-void-fix.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes-fix.patch
writeback-fix-break-condition-checkpatch-fixes.patch
aty128fb-properly-save-pci-state-before-changing-pci-pm-level-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-ata-sata_silc-needs-dmih.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work-fix.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
8250-fix-boot-hang-with-serial-console-when-using-with-serial-over-lan-port-fix.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-uninline-lock_fb_info.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
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

