From: akpm@linux-foundation.org
Subject: [folded] kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch removed from -mm tree
Date: Thu, 02 Apr 2009 16:24:54 -0700
Message-ID: <200904022324.n32NOsct012325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759288AbZDBX3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 19:29:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, horms@verge.net.au, nhorman@tuxdriver.com, oomichi@mxs.nes.nec.co.jp, randy.dunlap@oracle.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch

This patch was dropped because it was folded into kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

guys...

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix kernel/printk.c
--- a/kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix
+++ a/kernel/printk.c
@@ -151,7 +151,7 @@ void log_buf_kexec_setup(void)
 	VMCOREINFO_SYMBOL(log_buf);
 	VMCOREINFO_SYMBOL(log_end);
 	VMCOREINFO_SYMBOL(log_buf_len);
-	VMCOREINFO_SYMBOL(logged_chars)
+	VMCOREINFO_SYMBOL(logged_chars);
 }
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
workqueue-add-to_delayed_work-helper-function.patch
simplify-copy_thread.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-show-memcg-information-during-oom.patch
forget_original_parent-do-not-abuse-child-ptrace_entry.patch
hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
nbd-add-locking-to-nbd_ioctl.patch
edac-new-ppc4xx-driver-module.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
flex-onenand-support-v2-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
xtensa-add-flat-support-checkpatch-fixes.patch
max3100-spi-uart-driver-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
kernel-auditscc-fix-warning.patch
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
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

