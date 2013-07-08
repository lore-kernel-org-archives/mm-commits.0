From: akpm@linux-foundation.org
Subject: [folded-merged]
 reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 15:33:44 -0700
Message-ID: <51db3e48.m6PObcTjQo91Zktq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHWdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:33:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, rja@sgi.com, hpa@zytor.com, holt@sgi.com, gxt@mprc.pku.edu.cn, akpm@linux-foundation.org

Subject: [folded-merged] reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,gxt@mprc.pku.edu.cn,holt@sgi.com,hpa@zytor.com,rja@sgi.com,rmk+kernel@arm.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:33:44 -0700


The patch titled
     Subject: reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix
has been removed from the -mm tree.  Its filename was
     reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch

This patch was dropped because it was folded into reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix

fix arch/arm/mach-socfpga/socfpga.c

Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-socfpga/socfpga.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-socfpga/socfpga.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix arch/arm/mach-socfpga/socfpga.c
--- a/arch/arm/mach-socfpga/socfpga.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix
+++ a/arch/arm/mach-socfpga/socfpga.c
@@ -96,7 +96,7 @@ static void socfpga_cyclone5_restart(enu
 
 	temp = readl(rst_manager_base_addr + SOCFPGA_RSTMGR_CTRL);
 
-	if (mode == 'h')
+	if (mode == REBOOT_HARD)
 		temp |= RSTMGR_CTRL_SWCOLDRSTREQ;
 	else
 		temp |= RSTMGR_CTRL_SWWARMRSTREQ;
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
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch

