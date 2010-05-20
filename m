From: akpm@linux-foundation.org
Subject: + memcg-clean-up-memory-thresholds-fix.patch added to -mm tree
Date: Thu, 20 May 2010 12:45:14 -0700
Message-ID: <201005201945.o4KJjE5g000997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754429Ab0ETTqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 15:46:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, ext-phil.2.carmody@nokia.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-clean-up-memory-thresholds-fix
has been added to the -mm tree.  Its filename is
     memcg-clean-up-memory-thresholds-fix.patch

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
Subject: memcg-clean-up-memory-thresholds-fix
From: Andrew Morton <akpm@linux-foundation.org>

repair comment

Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-clean-up-memory-thresholds-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-memory-thresholds-fix
+++ a/mm/memcontrol.c
@@ -164,8 +164,8 @@ struct mem_cgroup_thresholds {
 	struct mem_cgroup_threshold_ary *primary;
 	/*
 	 * Spare threshold array.
-	 * It needed to make mem_cgroup_unregister_event() "never fail".
-	 * It must be able to store at least primary->size - 1 entires.
+	 * This is needed to make mem_cgroup_unregister_event() "never fail".
+	 * It must be able to store at least primary->size - 1 entries.
 	 */
 	struct mem_cgroup_threshold_ary *spare;
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths-fix.patch
x86-platform-driver-intelligent-power-sharing-driver-checkpatch-fixes.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
dib3000mc-reduce-large-stack-usage-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
hpet-factor-timer-allocate-from-open.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
fix-stop_machine-reimplement-using-cpu_stop.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix-2.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-spelling.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
mm-introduce-free_pages_prepare-fix.patch
cpu-mem-hotplug-enable-cpus-online-before-local-memory-online-fix.patch
cpu-mem-hotplug-enable-cpus-online-before-local-memory-online-checkpatch-fixes.patch
highmem-remove-unneeded-ifdef-config_trace_irqflags_support-for-debug_kmap_atomic.patch
mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset-fix.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix-fix.patch
include-asm-generic-kmap_typesh-remove-km_sync_icache-and-km_sync_dcache.patch
include-asm-generic-kmap_typesh-add-helpful-reminder.patch
dynamic_debug-fix-documentation-errors-checkpatch-fixes.patch
lib-introduce-common-method-to-convert-hex-digits-fix.patch
lib-introduce-common-method-to-convert-hex-digits-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
crc32-major-optimization-checkpatch-fixes.patch
hwmon-add-ti-ads7871-a-d-converter-driver-checkpatch-fixes.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
s3c-fb-add-s5pv210-support-and-some-features-checkpatch-fixes.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
memcg-move-charge-of-file-pages-fix-4.patch
memcg-clean-up-memory-thresholds-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
ipc-semc-optimize-update_queue-for-bulk-wakeup-calls-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix-2.patch
ipmi-update-driver-to-use-dev_printk-and-its-constructs-checkpatch-fixes.patch
pids-increase-pid_max-based-on-num_possible_cpus-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file-checkpatch-fixes.patch
aio-fix-the-compat-vectored-operations-checkpatch-fixes.patch
aio-fix-the-compat-vectored-operations-fix.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
x86_32-use-asm-generic-scatterlisth.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch

