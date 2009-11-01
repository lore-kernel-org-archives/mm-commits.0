From: akpm@linux-foundation.org
Subject: [obsolete] crypto-nfg.patch removed from -mm tree
Date: Sun, 01 Nov 2009 12:53:40 -0800
Message-ID: <200911012053.nA1Krf9F015121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386AbZKAUyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 1 Nov 2009 15:54:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, herbert@gondor.apana.org.au, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     crypto nfg
has been removed from the -mm tree.  Its filename was
     crypto-nfg.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crypto nfg
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/crypto/ghash-clmulni-intel_asm.S: Assembler messages:
arch/x86/crypto/ghash-clmulni-intel_asm.S:103: Error: no such instruction: `pshufb %xmm5,%xmm0'
arch/x86/crypto/ghash-clmulni-intel_asm.S:105: Error: no such instruction: `pshufb %xmm5,%xmm0'
arch/x86/crypto/ghash-clmulni-intel_asm.S:119: Error: no such instruction: `pshufb %xmm5,%xmm0'
arch/x86/crypto/ghash-clmulni-intel_asm.S:123: Error: no such instruction: `pshufb %xmm5,%xmm6'
arch/x86/crypto/ghash-clmulni-intel_asm.S:130: Error: no such instruction: `pshufb %xmm5,%xmm0'
arch/x86/crypto/ghash-clmulni-intel_asm.S:143: Error: no such instruction: `pshufb %xmm5,%xmm0'

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN crypto/Kconfig~crypto-nfg crypto/Kconfig
--- a/crypto/Kconfig~crypto-nfg
+++ a/crypto/Kconfig
@@ -443,6 +443,7 @@ config CRYPTO_WP512
 config CRYPTO_GHASH_CLMUL_NI_INTEL
 	tristate "GHASH digest algorithm (CLMUL-NI accelerated)"
 	depends on (X86 || UML_X86) && 64BIT
+	depends on BROKEN
 	select CRYPTO_SHASH
 	select CRYPTO_CRYPTD
 	help
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
alpha-move-thread_size-definition-outside-ifndef-assembly.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
crypto-add-pclmulqdq-accelerated-ghash-implementation-fix.patch
crypto-nfg.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
acpi-remove-nid_inval-checkpatch-fixes.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
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

