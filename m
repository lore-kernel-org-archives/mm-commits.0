From: akpm@linux-foundation.org
Subject: + hwmon-w83627ehf-updates-checkpatch-fixes.patch added to -mm tree
Date: Fri, 16 Oct 2009 15:29:13 -0700
Message-ID: <200910162229.n9GMTD6r019603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbZJPW3L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 18:29:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, daniel.blueman@gmail.com


The patch titled
     hwmon-w83627ehf-updates-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     hwmon-w83627ehf-updates-checkpatch-fixes.patch

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
Subject: hwmon-w83627ehf-updates-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#44: FILE: drivers/hwmon/w83627ehf.c:8:
+                        Daniel J Blueman <daniel.blueman@gmail.com>$

WARNING: line over 80 characters
#88: FILE: drivers/hwmon/w83627ehf.c:306:
+			     4->variable thermal cruise (also called SmartFan III) */

WARNING: line over 80 characters
#111: FILE: drivers/hwmon/w83627ehf.c:544:
+						W83627EHF_REG_FAN_START_OUTPUT[i]);

WARNING: line over 80 characters
#113: FILE: drivers/hwmon/w83627ehf.c:546:
+						W83627EHF_REG_FAN_STOP_OUTPUT[i]);

total: 1 errors, 3 warnings, 153 lines checked

./patches/hwmon-w83627ehf-updates.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/hwmon/w83627ehf~hwmon-w83627ehf-updates-checkpatch-fixes Documentation/hwmon/w83627ehf
diff -puN drivers/hwmon/w83627ehf.c~hwmon-w83627ehf-updates-checkpatch-fixes drivers/hwmon/w83627ehf.c
--- a/drivers/hwmon/w83627ehf.c~hwmon-w83627ehf-updates-checkpatch-fixes
+++ a/drivers/hwmon/w83627ehf.c
@@ -5,7 +5,7 @@
     Copyright (C) 2006  Yuan Mu (Winbond),
                         Rudolf Marek <r.marek@assembler.cz>
                         David Hubbard <david.c.hubbard@gmail.com>
-                        Daniel J Blueman <daniel.blueman@gmail.com>
+			Daniel J Blueman <daniel.blueman@gmail.com>
 
     Shamelessly ripped from the w83627hf driver
     Copyright (C) 2003  Mark Studebaker
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
8250_pci-add-ibm-saturn-serial-card-fix.patch
checkpatch-fix-false-export_symbol-warning-checkpatch-fixes.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
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

