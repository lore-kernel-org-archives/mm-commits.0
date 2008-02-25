From: akpm@linux-foundation.org
Subject: - copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:34 -0800
Message-ID: <200802250044.m1P0iYr5006119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550AbYBYAog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:44:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgross@linux.intel.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     copyright owner and author clean up for intel iommu and related files
has been removed from the -mm tree.  Its filename was
     copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: copyright owner and author clean up for intel iommu and related files
From: mark gross <mgross@linux.intel.com>

The following is a clean up and correction of the copyright holding
entities for the files associated with the intel iommu code.

Signed-off-by: <mgross@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/dmar.c        |    9 +++++----
 drivers/pci/intel-iommu.c |    7 ++++---
 drivers/pci/intel-iommu.h |    5 +++--
 drivers/pci/iova.c        |    3 ++-
 drivers/pci/iova.h        |    3 ++-
 5 files changed, 16 insertions(+), 11 deletions(-)

diff -puN drivers/pci/dmar.c~copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files drivers/pci/dmar.c
--- a/drivers/pci/dmar.c~copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files
+++ a/drivers/pci/dmar.c
@@ -14,11 +14,12 @@
  * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
  * Place - Suite 330, Boston, MA 02111-1307 USA.
  *
- * 	Copyright (C) Ashok Raj <ashok.raj@intel.com>
- *	Copyright (C) Shaohua Li <shaohua.li@intel.com>
- *	Copyright (C) Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ * Copyright (C) 2006-2008 Intel Corporation
+ * Author: Ashok Raj <ashok.raj@intel.com>
+ * Author: Shaohua Li <shaohua.li@intel.com>
+ * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  *
- * 	This file implements early detection/parsing of DMA Remapping Devices
+ * This file implements early detection/parsing of DMA Remapping Devices
  * reported to OS through BIOS via DMA remapping reporting (DMAR) ACPI
  * tables.
  */
diff -puN drivers/pci/intel-iommu.c~copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files
+++ a/drivers/pci/intel-iommu.c
@@ -14,9 +14,10 @@
  * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
  * Place - Suite 330, Boston, MA 02111-1307 USA.
  *
- * Copyright (C) Ashok Raj <ashok.raj@intel.com>
- * Copyright (C) Shaohua Li <shaohua.li@intel.com>
- * Copyright (C) Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ * Copyright (C) 2006-2008 Intel Corporation
+ * Author: Ashok Raj <ashok.raj@intel.com>
+ * Author: Shaohua Li <shaohua.li@intel.com>
+ * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  */
 
 #include <linux/init.h>
diff -puN drivers/pci/intel-iommu.h~copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files drivers/pci/intel-iommu.h
--- a/drivers/pci/intel-iommu.h~copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files
+++ a/drivers/pci/intel-iommu.h
@@ -14,8 +14,9 @@
  * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
  * Place - Suite 330, Boston, MA 02111-1307 USA.
  *
- * Copyright (C) Ashok Raj <ashok.raj@intel.com>
- * Copyright (C) Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ * Copyright (C) 2006-2008 Intel Corporation
+ * Author: Ashok Raj <ashok.raj@intel.com>
+ * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  */
 
 #ifndef _INTEL_IOMMU_H_
diff -puN drivers/pci/iova.c~copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files drivers/pci/iova.c
--- a/drivers/pci/iova.c~copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files
+++ a/drivers/pci/iova.c
@@ -3,7 +3,8 @@
  *
  * This file is released under the GPLv2.
  *
- * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ * Copyright (C) 2006-2008 Intel Corporation
+ * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  */
 
 #include "iova.h"
diff -puN drivers/pci/iova.h~copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files drivers/pci/iova.h
--- a/drivers/pci/iova.h~copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files
+++ a/drivers/pci/iova.h
@@ -3,7 +3,8 @@
  *
  * This file is released under the GPLv2.
  *
- * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ * Copyright (C) 2006-2008 Intel Corporation
+ * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  *
  */
 
_

Patches currently in -mm which might be from mgross@linux.intel.com are

pci-iova-rb-tree-setup-tweak.patch
iova-lockdep-false-alarm-fix.patch
