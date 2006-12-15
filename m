From: akpm@osdl.org
Subject: + funsoft-is-bust-on-sparc.patch added to -mm tree
Date: Thu, 14 Dec 2006 22:28:29 -0800
Message-ID: <200612150628.kBF6SXPI008904@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36488 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbWLOG2q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 01:28:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, david@funsoft.com, gregkh@suse.de


The patch titled
     funsoft-is-bust-on-sparc
has been added to the -mm tree.  Its filename is
     funsoft-is-bust-on-sparc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

rtc-warning-fix.patch
fix-vm_events_fold_cpu-build-breakage-fix.patch
build-compileh-earlier.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
git-acpi-cpufreq-fixup.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-more-borkage.patch
alsa-workqueue-fixes.patch
arm-systemh-build-fix.patch
git-drm.patch
ia64-enable-config_debug_spinlock_sleep.patch
infiniband-fix-for-gregkh-depredations.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
driver-for-silan-sc92031-netdev-include-fix.patch
driver-for-silan-sc92031-netdev-fix-more.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-legacy-resource-fix-tidy.patch
pci-disable-multithreaded-probing.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
fix-gregkh-usb-usb-ehci-hcd-add-shadow-budget-code.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
add-memcpy_uncached_read-fix.patch
add-memcpy_uncached_read-tidy.patch
touchkit-ps-2-touchscreen-driver.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
nfs-fix-nr_file_dirty-underflow-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
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
squash-ipc-warnings.patch
squash-udf-warnings.patch
funsoft-is-bust-on-sparc.patch

