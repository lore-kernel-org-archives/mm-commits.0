From: akpm@linux-foundation.org
Subject: + copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:28:32 -0800
Message-ID: <200802230729.m1N7TLXW017895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891AbYBWH3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:29:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgross@linux.intel.com, greg@kroah.com


The patch titled
     copyright owner and author clean up for intel iommu and related files
has been added to the -mm tree.  Its filename is
     copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files.patch

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

copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files.patch
pci-iova-rb-tree-setup-tweak.patch
iova-lockdep-false-alarm-fix.patch
