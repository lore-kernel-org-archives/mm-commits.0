From: akpm@osdl.org
Subject: - funsoft-is-bust-on-sparc.patch removed from -mm tree
Date: Thu, 21 Dec 2006 12:10:36 -0800
Message-ID: <200612212010.kBLKAah8003577@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36579 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423081AbWLUUKu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 15:10:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, david@funsoft.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     funsoft-is-bust-on-sparc
has been removed from the -mm tree.  Its filename was
     funsoft-is-bust-on-sparc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: funsoft-is-bust-on-sparc
From: Andrew Morton <akpm@osdl.org>

drivers/usb/serial/funsoft.c: In function `funsoft_ioctl':
drivers/usb/serial/funsoft.c:35: warning: dereferencing `void *' pointer
drivers/usb/serial/funsoft.c:35: error: request for member `c_iflag' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_iflag' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_iflag' in something not a structure or union
drivers/usb/serial/funsoft.c:35: warning: type defaults to `int' in declaration of `type name'
drivers/usb/serial/funsoft.c:35: warning: dereferencing `void *' pointer
drivers/usb/serial/funsoft.c:35: error: request for member `c_oflag' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_oflag' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_oflag' in something not a structure or union
drivers/usb/serial/funsoft.c:35: warning: type defaults to `int' in declaration of `type name'
drivers/usb/serial/funsoft.c:35: warning: dereferencing `void *' pointer
drivers/usb/serial/funsoft.c:35: error: request for member `c_cflag' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_cflag' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_cflag' in something not a structure or union
drivers/usb/serial/funsoft.c:35: warning: type defaults to `int' in declaration of `type name'
drivers/usb/serial/funsoft.c:35: warning: dereferencing `void *' pointer
drivers/usb/serial/funsoft.c:35: error: request for member `c_lflag' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_lflag' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_lflag' in something not a structure or union
drivers/usb/serial/funsoft.c:35: warning: type defaults to `int' in declaration of `type name'
drivers/usb/serial/funsoft.c:35: warning: dereferencing `void *' pointer
drivers/usb/serial/funsoft.c:35: error: request for member `c_line' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_line' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_line' in something not a structure or union
drivers/usb/serial/funsoft.c:35: warning: type defaults to `int' in declaration of `type name'
drivers/usb/serial/funsoft.c:35: warning: dereferencing `void *' pointer
drivers/usb/serial/funsoft.c:35: error: request for member `c_cc' in something not a structure or union
drivers/usb/serial/funsoft.c:35: warning: dereferencing `void *' pointer
drivers/usb/serial/funsoft.c:35: error: request for member `c_cc' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_cc' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_cc' in something not a structure or union
drivers/usb/serial/funsoft.c:35: warning: type defaults to `int' in declaration of `type name'
drivers/usb/serial/funsoft.c:35: warning: dereferencing `void *' pointer
drivers/usb/serial/funsoft.c:35: error: request for member `c_cc' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_cc' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_cc' in something not a structure or union
drivers/usb/serial/funsoft.c:35: warning: type defaults to `int' in declaration of `type name'
drivers/usb/serial/funsoft.c:35: warning: dereferencing `void *' pointer
drivers/usb/serial/funsoft.c:35: error: request for member `c_cc' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_cc' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_cc' in something not a structure or union
drivers/usb/serial/funsoft.c:35: warning: type defaults to `int' in declaration of `type name'
drivers/usb/serial/funsoft.c:35: warning: dereferencing `void *' pointer
drivers/usb/serial/funsoft.c:35: error: request for member `c_cc' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_cc' in something not a structure or union
drivers/usb/serial/funsoft.c:35: error: request for member `c_cc' in something not a structure or union
drivers/usb/serial/funsoft.c:35: warning: type defaults to `int' in declaration of `type name'

Cc: David Clare <david@funsoft.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/serial/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/Kconfig~funsoft-is-bust-on-sparc drivers/usb/serial/Kconfig
--- a/drivers/usb/serial/Kconfig~funsoft-is-bust-on-sparc
+++ a/drivers/usb/serial/Kconfig
@@ -170,7 +170,7 @@ config USB_SERIAL_FTDI_SIO
 
 config USB_SERIAL_FUNSOFT
 	tristate "USB Fundamental Software Dongle Driver"
-	depends on USB_SERIAL
+	depends on USB_SERIAL && !(SPARC || SPARC64)
 	---help---
 	  Say Y here if you want to use the Fundamental Software dongle.
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
truncate-clear-page-dirtiness-before-running-try_to_free_buffers.patch
kvm-do-not-export-unsupported-msrs-to-userspace-tweak.patch
rtc-warning-fix.patch
fix-vm_events_fold_cpu-build-breakage-fix.patch
smc911-workqueue-fixes.patch
schedule_timeout-improve-warning-message.patch
relay-remove-inlining.patch
increase-cardbus_mem_size.patch
down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
build-compileh-earlier.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixups.patch
cifs-sprintf-fix.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-input.patch
git-libata-all.patch
git-libata-all-fixup.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
driver-for-silan-sc92031-netdev.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
add-memcpy_uncached_read.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
spi-controller-driver-for-omap-microwire-tidy.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
sched-improve-efficiency-of-sched_fork-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

