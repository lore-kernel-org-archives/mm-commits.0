From: akpm@linux-foundation.org
Subject: - docbook-fix-kernel-api-source-files.patch removed from -mm tree
Date: Mon, 03 Mar 2008 13:02:55 -0800
Message-ID: <200803032102.m23L2t4b006281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430AbYCCVDw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:03:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     docbook: fix kernel-api source files
has been removed from the -mm tree.  Its filename was
     docbook-fix-kernel-api-source-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: fix kernel-api source files
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook problems in kernel-api.tmpl.  These cause the generated docbook to
be incorrect.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/transport_class.c |    4 +---
 drivers/pci/rom.c              |    3 +--
 mm/truncate.c                  |    3 +--
 3 files changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/base/transport_class.c~docbook-fix-kernel-api-source-files drivers/base/transport_class.c
--- a/drivers/base/transport_class.c~docbook-fix-kernel-api-source-files
+++ a/drivers/base/transport_class.c
@@ -126,9 +126,7 @@ static int transport_setup_classdev(stru
 }
 
 /**
- * transport_setup_device - declare a new dev for transport class association
- *			    but don't make it visible yet.
- *
+ * transport_setup_device - declare a new dev for transport class association but don't make it visible yet.
  * @dev: the generic device representing the entity being added
  *
  * Usually, dev represents some component in the HBA system (either
diff -puN drivers/pci/rom.c~docbook-fix-kernel-api-source-files drivers/pci/rom.c
--- a/drivers/pci/rom.c~docbook-fix-kernel-api-source-files
+++ a/drivers/pci/rom.c
@@ -242,8 +242,7 @@ void pci_remove_rom(struct pci_dev *pdev
 #endif  /*  0  */
 
 /**
- * pci_cleanup_rom - internal routine for freeing the ROM copy created
- * by pci_map_rom_copy called from remove.c
+ * pci_cleanup_rom - free the ROM copy created by pci_map_rom_copy
  * @pdev: pointer to pci device struct
  *
  * Free the copied ROM if we allocated one.
diff -puN mm/truncate.c~docbook-fix-kernel-api-source-files mm/truncate.c
--- a/mm/truncate.c~docbook-fix-kernel-api-source-files
+++ a/mm/truncate.c
@@ -135,8 +135,7 @@ invalidate_complete_page(struct address_
 }
 
 /**
- * truncate_inode_pages - truncate range of pages specified by start and
- * end byte offsets
+ * truncate_inode_pages - truncate range of pages specified by start & end byte offsets
  * @mapping: mapping to truncate
  * @lstart: offset from which to truncate
  * @lend: offset to which to truncate
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
kprobes-move-kprobe-examples-to-samples.patch
x86-visws-fix-printk-format-warnings.patch
apanel-fix-kconfig-dependencies.patch
let-log_buf_shift-default-to-17.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
profile-likely-unlikely-macros.patch

