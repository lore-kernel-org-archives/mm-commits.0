From: akpm@linux-foundation.org
Subject: - x86-export-is_uv_system.patch removed from -mm tree
Date: Mon, 04 Aug 2008 12:50:56 -0700
Message-ID: <200808041950.m74JouGH026995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336AbYHDTvS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 15:51:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dcn@sgi.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: export is_uv_system()
has been removed from the -mm tree.  Its filename was
     x86-export-is_uv_system.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: export is_uv_system()
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "is_uv_system" [drivers/misc/sgi-xp/xpnet.ko] undefined!
ERROR: "is_uv_system" [drivers/misc/sgi-xp/xpc.ko] undefined!
ERROR: "is_uv_system" [drivers/misc/sgi-xp/xp.ko] undefined!
ERROR: "is_uv_system" [drivers/misc/sgi-gru/gru.ko] undefined!

(is sgi-xp an x86-64 driver?)

Cc: Dean Nelson <dcn@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/genx2apic_uv_x.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/kernel/genx2apic_uv_x.c~x86-export-is_uv_system arch/x86/kernel/genx2apic_uv_x.c
--- a/arch/x86/kernel/genx2apic_uv_x.c~x86-export-is_uv_system
+++ a/arch/x86/kernel/genx2apic_uv_x.c
@@ -53,6 +53,7 @@ int is_uv_system(void)
 {
 	return uv_system_type != UV_NONE;
 }
+EXPORT_SYMBOL(is_uv_system);
 
 DEFINE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 EXPORT_PER_CPU_SYMBOL_GPL(__uv_hub_info);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
x86-export-is_uv_system.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
git-agpgart.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
git-drm.patch
drivers-media-video-vinoc-needs-v4l2-ioctlh.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-dlm.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-kvm.patch
git-mtd.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
drivers-mtd-nand-nandsimc-fix-printk-warnings.patch
git-ubi-git-rejects.patch
bridge-send-correct-mtu-value-in-pmtu.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
git-nfsd.patch
git-pci-current.patch
sched-type-fix.patch
git-sh.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
usb-hubc-fix-build-with-config_pm=n.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

