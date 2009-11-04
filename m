From: akpm@linux-foundation.org
Subject: + msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch added to -mm tree
Date: Tue, 03 Nov 2009 16:14:00 -0800
Message-ID: <200911040014.nA40E1Rm013115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746AbZKDAOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 19:14:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, pavel@ucw.cz


The patch titled
     msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch

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
Subject: msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#28: FILE: arch/arm/mach-msm/include/mach/mmc.h:12:
+        struct sdio_cis cis;$

ERROR: code indent should use tabs where possible
#29: FILE: arch/arm/mach-msm/include/mach/mmc.h:13:
+        struct sdio_cccr cccr;$

ERROR: code indent should use tabs where possible
#30: FILE: arch/arm/mach-msm/include/mach/mmc.h:14:
+        struct sdio_embedded_func *funcs;$

ERROR: code indent should use tabs where possible
#31: FILE: arch/arm/mach-msm/include/mach/mmc.h:15:
+        int num_funcs;$

WARNING: line over 80 characters
#39: FILE: arch/arm/mach-msm/include/mach/mmc.h:23:
+	int (*register_status_notify)(void (*callback)(int card_present, void *dev_id), void *dev_id);

total: 4 errors, 1 warnings, 50 lines checked

./patches/msm_sdccc-add-missing-include-fix-compilation.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/arm/mach-msm/include/mach/mmc.h~msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes arch/arm/mach-msm/include/mach/mmc.h
--- a/arch/arm/mach-msm/include/mach/mmc.h~msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes
+++ a/arch/arm/mach-msm/include/mach/mmc.h
@@ -9,10 +9,10 @@
 #include <linux/mmc/sdio_func.h>
 
 struct embedded_sdio_data {
-        struct sdio_cis cis;
-        struct sdio_cccr cccr;
-        struct sdio_embedded_func *funcs;
-        int num_funcs;
+	struct sdio_cis cis;
+	struct sdio_cccr cccr;
+	struct sdio_embedded_func *funcs;
+	int num_funcs;
 };
 
 struct mmc_platform_data {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
alpha-move-thread_size-definition-outside-ifndef-assembly.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
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
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
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

