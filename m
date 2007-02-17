From: akpm@linux-foundation.org
Subject: - parisc-fix-module_param-iommu-permission.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:17:09 -0800
Message-ID: <200702170717.l1H7H92d021771@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51243 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946550AbXBQHRc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:17:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, kyle@mcmartin.ca, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     parisc: fix module_param iommu permission
has been removed from the -mm tree.  Its filename was
     parisc-fix-module_param-iommu-permission.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: parisc: fix module_param iommu permission
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix/change module_param permissions parameter from an init value
to a permission value.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/sba_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parisc/sba_iommu.c~parisc-fix-module_param-iommu-permission drivers/parisc/sba_iommu.c
--- a/drivers/parisc/sba_iommu.c~parisc-fix-module_param-iommu-permission
+++ a/drivers/parisc/sba_iommu.c
@@ -109,7 +109,7 @@ static unsigned long piranha_bad_128k = 
 
 #ifdef SBA_AGP_SUPPORT
 static int sba_reserve_agpgart = 1;
-module_param(sba_reserve_agpgart, int, 1);
+module_param(sba_reserve_agpgart, int, 0444);
 MODULE_PARM_DESC(sba_reserve_agpgart, "Reserve half of IO pdir as AGPGART");
 #endif
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
build-errors-uevent-with-config_sysfs=n.patch
git-drm.patch
sata-use-null-for-ptrs.patch
git-mtd.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
ueagle-atmc-needs-schedh.patch
kernel-doc-include-struct-short-description-in-title.patch
tty-use-null-for-ptrs.patch
cdrom-use-unsigned-bitfields.patch
update-doc-oops-tracingtxt-for-taint_user.patch
update-doc-oops-tracingtxt-for-taint_user-fix.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
