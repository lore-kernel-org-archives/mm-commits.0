From: akpm@osdl.org
Subject: + megaraid-more-kernel-doc-fixes.patch added to -mm tree
Date: Wed, 10 Jan 2007 16:54:24 -0800
Message-ID: <200701110054.l0B0sOm5012998@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41875 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965285AbXAKAya (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 19:54:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     megaraid: more kernel-doc fixes
has been added to the -mm tree.  Its filename is
     megaraid-more-kernel-doc-fixes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: megaraid: more kernel-doc fixes
From: Randy Dunlap <randy.dunlap@oracle.com>

More megaraid kernel-doc fixes.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid/mbox_defs.h   |    2 +-
 drivers/scsi/megaraid/mega_common.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/megaraid/mbox_defs.h~megaraid-more-kernel-doc-fixes drivers/scsi/megaraid/mbox_defs.h
--- a/drivers/scsi/megaraid/mbox_defs.h~megaraid-more-kernel-doc-fixes
+++ a/drivers/scsi/megaraid/mbox_defs.h
@@ -748,7 +748,7 @@ typedef struct {
 
 
 /**
- * private_bios_data - bios private data for boot devices
+ * struct private_bios_data - bios private data for boot devices
  * @geometry	: bits 0-3 - BIOS geometry, 0x0001 - 1GB, 0x0010 - 2GB,
  *		0x1000 - 8GB, Others values are invalid
  * @unused	: bits 4-7 are unused
diff -puN drivers/scsi/megaraid/mega_common.h~megaraid-more-kernel-doc-fixes drivers/scsi/megaraid/mega_common.h
--- a/drivers/scsi/megaraid/mega_common.h~megaraid-more-kernel-doc-fixes
+++ a/drivers/scsi/megaraid/mega_common.h
@@ -271,7 +271,7 @@ typedef struct {
 #define ASSERT(expression)
 #endif
 
-/*
+/**
  * struct mraid_pci_blk - structure holds DMA memory block info
  * @vaddr		: virtual address to a memory block
  * @dma_addr		: DMA handle to a memory block
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-alsa.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-rc-fixes.patch
megaraid-fix-kernel-doc.patch
math-emu-setcc-avoid-gcc-extension.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-showblockedtasks-is-sysrq-w.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
megaraid-more-kernel-doc-fixes.patch
docbook-add-edd-firmware-interfaces.patch
kernel-doc-fix-some-odd-spacing-issues.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
