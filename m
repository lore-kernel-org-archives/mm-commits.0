From: akpm@linux-foundation.org
Subject: + convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch added to -mm tree
Date: Wed, 19 Sep 2007 17:10:11 -0700
Message-ID: <200709200010.l8K0ABvb019763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50106 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbXITAKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Sep 2007 20:10:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, paulus@samba.org, travis@sgi.com


The patch titled
     convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2
has been added to the -mm tree.  Its filename is
     convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mike Travis <travis@sgi.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/smp.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-powerpc/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2 include/asm-powerpc/smp.h
--- a/include/asm-powerpc/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2
+++ a/include/asm-powerpc/smp.h
@@ -25,8 +25,8 @@
 
 #ifdef CONFIG_PPC64
 #include <asm/paca.h>
-#include <asm/percpu.h>
 #endif
+#include <asm/percpu.h>
 
 extern int boot_cpuid;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-dac960-driver-on-machines-which-dont-support-64-bit-dma-fix.patch
disable-sys_timerfd-for-2623.patch
uml-fix-irqstack-crash.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
alsa-procfs-fix.patch
git-alsa-sc6000-build-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
fix-gregkh-driver-sysfs-spit-a-warning-to-users-when-they-try-to-create-a-duplicate-sysfs-file.patch
fix-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
fix-2--gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
fix-gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
git-dvb.patch
git-dvb-fixup-2.patch
git-dvb-build-fix.patch
i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
git-infiniband.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
git-input-fixup.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers-fix.patch
git-jg-misc-fix.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-libata-all.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
ide-arm-hack.patch
git-mips.patch
git-mips-fixup.patch
mips-add-gpio-support-to-the-bcm947xx-platform-update.patch
git-mmc.patch
git-mmc-fixup2.patch
mmc-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-net.patch
git-net-fixup.patch
git-net-fix-2.patch
nit-net-skge-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
net-atm-lecc-printk-warning-fix.patch
git-net-af_iucv-fixes.patch
git-net-sgiseeq-fix.patch
git-net-fix-ibmveth.patch
git-net-broke-ipg-add-ip1000a-driver-to-kernel-tree.patch
git-backlight.patch
git-backlight-build-fix.patch
git-backlight-dependency-fix.patch
git-net-vs-git-nfs.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-nfsd-fixup.patch
git-ocfs2.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
i386-compaq-evo-n800c-needs-pci-bus-renumbering-fix.patch
git-s390.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
git-scsi-misc-arcmsr-build-fix.patch
advansys-printk-fix.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-block-fix-u14-34f.patch
git-block-fix-qlogicpti-build.patch
git-unionfs.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
git-net-vs-git-wireless.patch
git-net-vs-git-wireless-2.patch
net-add-ath5k-wireless-driver-fix.patch
git-net-vs-git-wireless-3.patch
git-net-broke-git-wireless.patch
iwl3945-is-bust.patch
more-wireless-borkage.patch
more-wireless-borkage-2.patch
more-wireless-borkage-3.patch
p54pci-terminate-pci-table.patch
git-wireless-fix-99.patch
git-wireless-b44-is-bust.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-fix.patch
git-xfs.patch
git-kgdb-fixup.patch
i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
i386-and-x86_64-randomize-brk-fix.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
pvrusb2-hdw-terminate-usb-device-id-table-differently.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
keys-make-request_key-and-co-fundamentally-asynchronous-vs-git-mmc.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
export-font_vga_8x16.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
isolate-some-explicit-usage-of-task-tgid-fix-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
