From: akpm@linux-foundation.org
Subject: - git-acpi-fix-git-rejects.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:19:50 -0700
Message-ID: <200707230919.l6N9JpAg015858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43290 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756605AbXGWJUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:20:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     git-acpi-fix-git-rejects
has been removed from the -mm tree.  Its filename was
     git-acpi-fix-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-acpi-fix-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/bin.c         |    8 --------
 include/asm-ia64/pci.h |    9 ---------
 2 files changed, 17 deletions(-)

diff -puN fs/sysfs/bin.c~git-acpi-fix-git-rejects fs/sysfs/bin.c
--- a/fs/sysfs/bin.c~git-acpi-fix-git-rejects
+++ a/fs/sysfs/bin.c
@@ -44,11 +44,7 @@ fill_read(struct dentry *dentry, char *b
 
 	sysfs_put_active_two(attr_sd);
 
-<<<<<<< HEAD/fs/sysfs/bin.c
-	return rc;
-=======
 	return attr->read(kobj, attr, buffer, off, count);
->>>>>>> /fs/sysfs/bin.c
 }
 
 static ssize_t
@@ -105,11 +101,7 @@ flush_write(struct dentry *dentry, char 
 
 	sysfs_put_active_two(attr_sd);
 
-<<<<<<< HEAD/fs/sysfs/bin.c
-	return rc;
-=======
 	return attr->write(kobj, attr, buffer, offset, count);
->>>>>>> /fs/sysfs/bin.c
 }
 
 static ssize_t write(struct file *file, const char __user *userbuf,
diff -puN include/asm-ia64/pci.h~git-acpi-fix-git-rejects include/asm-ia64/pci.h
--- a/include/asm-ia64/pci.h~git-acpi-fix-git-rejects
+++ a/include/asm-ia64/pci.h
@@ -98,21 +98,12 @@ extern int pci_mmap_page_range (struct p
 #define HAVE_PCI_LEGACY
 extern int pci_mmap_legacy_page_range(struct pci_bus *bus,
 				      struct vm_area_struct *vma);
-<<<<<<< HEAD/include/asm-ia64/pci.h
-extern ssize_t pci_read_legacy_io(struct kobject *kobj,
-				  struct bin_attribute *bin_attr,
-				  char *buf, loff_t off, size_t count);
-extern ssize_t pci_write_legacy_io(struct kobject *kobj,
-				   struct bin_attribute *bin_attr,
-				   char *buf, loff_t off, size_t count);
-=======
 extern ssize_t pci_read_legacy_io(struct kobject *kobj,
 			struct bin_attribute *bin_attr, char *buf,
 			loff_t off, size_t count);
 extern ssize_t pci_write_legacy_io(struct kobject *kobj,
 			struct bin_attribute *bin_attr, char *buf,
 			loff_t off, size_t count);
->>>>>>> /include/asm-ia64/pci.h
 extern int pci_mmap_legacy_mem(struct kobject *kobj,
 			       struct bin_attribute *attr,
 			       struct vm_area_struct *vma);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-fix-git-rejects.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-dvb.patch
adbhid-produce-all-capslock-key-events-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mtd.patch
mtd-potential-leak-in-rfd_ftl_add_mtd-fix.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
ip_auto_config-fix-fix.patch
git-backlight-cr_bllcdc-build-fix.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-xfs-fixup.patch
git-kgdb-fixup-2.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
