From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:23:38 -0800
Message-ID: <200902122023.n1CKNcIb012112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493AbZBLUYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:24:11 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1CKNd1V027560
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2009 12:23:40 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/lowcore.h |    4 ----
 arch/x86/kernel/acpi/boot.c     |    5 -----
 2 files changed, 9 deletions(-)

diff -puN arch/s390/include/asm/lowcore.h~linux-next-git-rejects arch/s390/include/asm/lowcore.h
--- a/arch/s390/include/asm/lowcore.h~linux-next-git-rejects
+++ a/arch/s390/include/asm/lowcore.h
@@ -388,11 +388,7 @@ struct _lowcore
 	__u32	     ipib_checksum;	       /* 0xe08 */
 
 	/* Per cpu primary space access list */
-<<<<<<< HEAD:arch/s390/include/asm/lowcore.h
-	__u8	     pad_0xe04[0xe38-0xe04];   /* 0xe04 */
-=======
 	__u8	     pad_0xe0c[0xe38-0xe0c];   /* 0xe0c */
->>>>>>> FETCH_HEAD:arch/s390/include/asm/lowcore.h
 	__u64	     vdso_per_cpu_data;	       /* 0xe38 */
 	__u32	     paste[16];		       /* 0xe40 */
 
diff -puN arch/x86/kernel/acpi/boot.c~linux-next-git-rejects arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c~linux-next-git-rejects
+++ a/arch/x86/kernel/acpi/boot.c
@@ -961,7 +961,6 @@ void __init mp_register_ioapic(int id, u
 	nr_ioapics++;
 }
 
-<<<<<<< HEAD:arch/x86/kernel/acpi/boot.c
 int __init acpi_probe_gsi(void)
 {
 	int idx;
@@ -985,12 +984,8 @@ int __init acpi_probe_gsi(void)
 	return max_gsi + 1;
 }
 
-static void assign_to_mp_irq(struct mp_config_intsrc *m,
-				    struct mp_config_intsrc *mp_irq)
-=======
 static void assign_to_mp_irq(struct mpc_intsrc *m,
 				    struct mpc_intsrc *mp_irq)
->>>>>>> FETCH_HEAD:arch/x86/kernel/acpi/boot.c
 {
 	memcpy(mp_irq, m, sizeof(struct mpc_intsrc));
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

