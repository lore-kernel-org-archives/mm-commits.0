From: akpm@linux-foundation.org
Subject: [folded] const-constify-remaining-file_operations-fix.patch removed from -mm tree
Date: Thu, 01 Oct 2009 15:39:57 -0700
Message-ID: <200910012239.n91Mdv82032376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729AbZJAWj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2009 18:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     const-constify-remaining-file_operations-fix
has been removed from the -mm tree.  Its filename was
     const-constify-remaining-file_operations-fix.patch

This patch was dropped because it was folded into const-constify-remaining-file_operations.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: const-constify-remaining-file_operations-fix
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/kvm/../../../virt/kvm/kvm_main.c:2629: warning: initialization discards qualifiers from pointer target type
arch/x86/kvm/../../../virt/kvm/kvm_main.c:2630: warning: initialization discards qualifiers from pointer target type


Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN virt/kvm/kvm_main.c~const-constify-remaining-file_operations-fix virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~const-constify-remaining-file_operations-fix
+++ a/virt/kvm/kvm_main.c
@@ -2625,7 +2625,7 @@ static int vcpu_stat_get(void *_offset, 
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_stat_fops, vcpu_stat_get, NULL, "%llu\n");
 
-static struct file_operations *stat_fops[] = {
+static const struct file_operations *stat_fops[] = {
 	[KVM_STAT_VCPU] = &vcpu_stat_fops,
 	[KVM_STAT_VM]   = &vm_stat_fops,
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-input-inputc-fix-config_pm=n-warning.patch
const-constify-remaining-file_operations.patch
const-constify-remaining-file_operations-fix.patch
revert-m68k-convert-to-asm-generic-hardirqh.patch
serial167-fix-read-buffer-overflow.patch
sparc32-convert-to-asm-generic-hardirqh.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
st-fix-test-of-value-range-in-st_set_options.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
net-ipv4-tcpc-fix-min-type-mismatch-warning.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

