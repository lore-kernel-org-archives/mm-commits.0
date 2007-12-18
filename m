From: akpm@linux-foundation.org
Subject: + ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch added to -mm tree
Date: Tue, 18 Dec 2007 15:39:19 -0800
Message-ID: <200712182339.lBINdJEK027857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49200 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601AbXLRXjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 18:39:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, marcin.slusarz@gmail.com


The patch titled
     ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpat=
ch-fixes
has been added to the -mm tree.  Its filename is
     ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpat=
ch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-chec=
kpatch-fixes
=46rom: Andrew Morton <akpm@linux-foundation.org>

WARNING: no space between function name and open parenthesis '('
#22: FILE: drivers/usb/host/ehci-hcd.c:835:
+			schedule_status =3D qh_schedule (ehci, qh);

total: 0 errors, 1 warnings, 20 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Greg KH <greg@kroah.com>
Cc: Marcin =C5=9Alusarz <marcin.slusarz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ehci-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/host/ehci-hcd.c~ehci-hcd-fix-sparse-warning-about=
-shadowing-status-symbol-checkpatch-fixes drivers/usb/host/ehci-hcd.c
--- a/drivers/usb/host/ehci-hcd.c~ehci-hcd-fix-sparse-warning-about-sha=
dowing-status-symbol-checkpatch-fixes
+++ a/drivers/usb/host/ehci-hcd.c
@@ -832,7 +832,7 @@ static int ehci_urb_dequeue(struct usb_h
 				&& HC_IS_RUNNING (hcd->state)) {
 			int schedule_status;
=20
-			schedule_status =3D qh_schedule (ehci, qh);
+			schedule_status =3D qh_schedule(ehci, qh);
 			spin_unlock_irqrestore (&ehci->lock, flags);
=20
 			if (schedule_status !=3D 0) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
fix-headers_install.patch
revert-hibernation-use-temporary-page-tables-for-kernel-text-mapping-on=
-x86_64.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-powerpc-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
kernel-auditc-warning-fix.patch
git-cpufreq.patch
ppc-chrp-fix-possible-null-pointer-dereference.patch
gregkh-driver-kobject-change-drivers-cpuidle-sysfsc-to-use-kobject_init=
_and_add-fix.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.p=
atch
git-drm.patch
git-drm-fix.patch
intel-agp-enable-i915-recognition.patch
git-dvb.patch
git-dvb-one-videobuf_read_start-is-enough.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
git-hid.patch
revert-git-hrt.patch
ia64-slim-down-__clear_bit_unlock.patch
git-ieee1394.patch
git-infiniband.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-det=
ect-checkpatch-fixes.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-che=
ckpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
git-md-accel.patch
git-mips-fixup.patch
git-mmc.patch
git-mtd.patch
git-net.patch
git-net-vs-git-lblnet.patch
git-net-vs-git-lblnet-2.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
backlight-omap1-backlight-driver.patch
git-battery.patch
bluetooth-uninlining.patch
git-nfsd.patch
git-ocfs2-fixup.patch
quirk-enable-msi-mapping-on-ht1000.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-rc-fixes.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fi=
xes.patch
9p-util-fix-semaphore-handling.patch
git-watchdog.patch
git-watchdog-fixup.patch
add-support-for-sb1-hardware-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-fixup.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
i386-use-raw_smp_processor_id-in-die.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
bonding-locking-fix.patch
iwlwifi3945-4965-fix-rate-control-algo-reference-leak.patch
bcm43xx_debugfs-sscanf-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fi=
x.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fi=
x-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fix=
es.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.=
patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-t=
he-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.p=
atch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warni=
ng-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warni=
ng-message-fix.patch
alpha-atomic_add_return-should-return-int.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking=
-notifiers.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatc=
h-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patc=
h
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.pa=
tch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-express=
card-fix.patch
mark-rwsem-functions-as-__sched-for-wchan-profiling-fix.patch
sync_sb_inodes-propagate-errors.patch
add-have_oprofile.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-fix.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
64-bit-i_version-afs-fixes.patch
ext4-add-block-bitmap-validation.patch
ext4-fix-up-ext4fs_debug-builds.patch
ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks-fix.pa=
tch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.pa=
tch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-c=
hange-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch=
-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-=
fixes.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.=
patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_=
page-warning-fix.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cg=
roup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cg=
roup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cg=
roup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cg=
roup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember=
-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember=
-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies=
-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patc=
h
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patc=
h
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patc=
h
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patc=
h
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.pat=
ch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patc=
h
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patc=
h
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-check=
patch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.pat=
ch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-=
checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-=
fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-=
fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-=
fix-3.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-=
x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sani=
tize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
