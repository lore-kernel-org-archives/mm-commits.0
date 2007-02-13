From: akpm@linux-foundation.org
Subject: + pci-sysfs-kobject-kernel-doc-fixes.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:46:42 -0800
Message-ID: <200702130546.l1D5kgau022915@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55520 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbXBMFsi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:48:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     PCI/sysfs/kobject kernel-doc fixes
has been added to the -mm tree.  Its filename is
     pci-sysfs-kobject-kernel-doc-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PCI/sysfs/kobject kernel-doc fixes
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in PCI, sysfs, and kobject files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci-driver.c |    1 +
 drivers/pci/pci.c        |    2 +-
 fs/sysfs/file.c          |    2 +-
 lib/kobject.c            |    1 +
 4 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/pci/pci.c~pci-sysfs-kobject-kernel-doc-fixes drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-sysfs-kobject-kernel-doc-fixes
+++ a/drivers/pci/pci.c
@@ -1306,7 +1306,7 @@ pci_set_consistent_dma_mask(struct pci_d
 
 /**
  * pci_select_bars - Make BAR mask from the type of resource
- * @pdev: the PCI device for which BAR mask is made
+ * @dev: the PCI device for which BAR mask is made
  * @flags: resource type mask to be selected
  *
  * This helper routine makes bar mask from the type of resource.
diff -puN drivers/pci/pci-driver.c~pci-sysfs-kobject-kernel-doc-fixes drivers/pci/pci-driver.c
--- a/drivers/pci/pci-driver.c~pci-sysfs-kobject-kernel-doc-fixes
+++ a/drivers/pci/pci-driver.c
@@ -415,6 +415,7 @@ static struct kobj_type pci_driver_kobj_
  * __pci_register_driver - register a new pci driver
  * @drv: the driver structure to register
  * @owner: owner module of drv
+ * @mod_name: module name string
  * 
  * Adds the driver structure to the list of registered drivers.
  * Returns a negative value on error, otherwise 0. 
diff -puN fs/sysfs/file.c~pci-sysfs-kobject-kernel-doc-fixes fs/sysfs/file.c
--- a/fs/sysfs/file.c~pci-sysfs-kobject-kernel-doc-fixes
+++ a/fs/sysfs/file.c
@@ -62,7 +62,7 @@ static struct sysfs_ops subsys_sysfs_ops
 /**
  *	add_to_collection - add buffer to a collection
  *	@buffer:	buffer to be added
- *	@node		inode of set to add to
+ *	@node:		inode of set to add to
  */
 
 static inline void
diff -puN lib/kobject.c~pci-sysfs-kobject-kernel-doc-fixes lib/kobject.c
--- a/lib/kobject.c~pci-sysfs-kobject-kernel-doc-fixes
+++ a/lib/kobject.c
@@ -349,6 +349,7 @@ EXPORT_SYMBOL(kobject_set_name);
 /**
  *	kobject_rename - change the name of an object
  *	@kobj:	object in question.
+ *	@new_parent: object's new parent
  *	@new_name: object's new name
  */
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-drm.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
git-mtd.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
pci-sysfs-kobject-kernel-doc-fixes.patch
ueagle-atmc-needs-schedh.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
