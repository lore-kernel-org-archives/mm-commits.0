From: akpm@linux-foundation.org
Subject: [folded-merged]
 reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch removed from -mm tree
Date: Mon, 08 Jul 2013 15:33:46 -0700
Message-ID: <51db3e4a.rFo+mkn9vsIHA92d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHWdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:33:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, holt@sgi.com, fengguang.wu@intel.com, akpm@linux-foundation.org

Subject: [folded-merged] reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,fengguang.wu@intel.com,holt@sgi.com,rmk+kernel@arm.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:33:46 -0700


The patch titled
     Subject: reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix
has been removed from the -mm tree.  Its filename was
     reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch

This patch was dropped because it was folded into reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix

Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/omap4-restart.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/mach-omap2/omap4-restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix arch/arm/mach-omap2/omap4-restart.c
--- a/arch/arm/mach-omap2/omap4-restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix
+++ a/arch/arm/mach-omap2/omap4-restart.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/reboot.h>
 #include "prminst44xx.h"
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch
partitions-add-aix-lvm-partition-support-files.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch

