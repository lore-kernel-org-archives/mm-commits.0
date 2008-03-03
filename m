From: akpm@linux-foundation.org
Subject: + docbook-fix-kernel-api-source-files.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:23:36 -0800
Message-ID: <200803030723.m237NaXw004397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840AbYCCHXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:23:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     docbook: fix kernel-api source files
has been added to the -mm tree.  Its filename is
     docbook-fix-kernel-api-source-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
docbook-fix-filesystemstmpl-source-files.patch
docbook-fix-rapidio-source-files.patch
docbook-fix-scsi-source-file.patch
docbook-fix-kernel-api-source-files.patch
docbook-fix-fusion-source-files.patch

