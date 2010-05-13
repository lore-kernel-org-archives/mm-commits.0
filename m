From: akpm@linux-foundation.org
Subject: + kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch added to -mm tree
Date: Thu, 13 May 2010 14:36:43 -0700
Message-ID: <201005132136.o4DLahOo021692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758821Ab0EMVhO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 17:37:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, stefani@seibold.net


The patch titled
     kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch

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
Subject: kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: printk() should include KERN_ facility level
#144: FILE: samples/kfifo/bytestream-example.c:84:
+		printk("%d ", i);

WARNING: please, no space before tabs
#252: FILE: samples/kfifo/dma-example.c:25:
+^Iint ^I^I^Ii;$

WARNING: please, no space before tabs
#253: FILE: samples/kfifo/dma-example.c:26:
+^Iunsigned int ^I^Iret;$

WARNING: printk() should include KERN_ facility level
#426: FILE: samples/kfifo/inttype-example.c:80:
+		printk("%d ", i);

WARNING: do not add new typedefs
#560: FILE: samples/kfifo/record-example.c:53:
+typedef STRUCT_KFIFO_REC_1(FIFO_SIZE) mytest;

total: 0 errors, 5 warnings, 622 lines checked

./patches/kfifo-add-example-files-to-the-kernel-sample-directory.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kfifo/dma-example.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN samples/kfifo/dma-example.c~kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes samples/kfifo/dma-example.c
--- a/samples/kfifo/dma-example.c~kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes
+++ a/samples/kfifo/dma-example.c
@@ -22,8 +22,8 @@ static struct kfifo fifo;
 
 static int __init example_init(void)
 {
-	int 			i;
-	unsigned int 		ret;
+	int			i;
+	unsigned int		ret;
 	struct scatterlist	sg[10];
 
 	printk(KERN_INFO "DMA fifo test start\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmc-at91_mci-modify-cache-flush-routines-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
cpufreq-fix-race-condition-in-store_scaling_governor-fix.patch
jfs-free-sbi-memory-in-error-path.patch
fix-drm-radeon-kms-hdmi-irq-support.patch
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
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix.patch
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
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix-fix.patch
include-asm-generic-kmap_typesh-remove-km_sync_icache-and-km_sync_dcache.patch
dynamic_debug-fix-documentation-errors-checkpatch-fixes.patch
lib-introduce-common-method-to-convert-hex-digits-fix.patch
lib-introduce-common-method-to-convert-hex-digits-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
crc32-major-optimization-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
hwmon-add-ti-ads7871-a-d-converter-driver-checkpatch-fixes.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
s3c-fb-add-s5pv210-support-and-some-features-checkpatch-fixes.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
memcg-move-charge-of-file-pages-fix-4.patch
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
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
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

