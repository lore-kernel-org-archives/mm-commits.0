From: akpm@linux-foundation.org
Subject: - pnp-fix-missing-kernel-doc-notation.patch removed from -mm tree
Date: Tue, 06 May 2008 11:59:02 -0700
Message-ID: <200805061859.m46Ix2lQ022092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755660AbYEFTAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 15:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     pnp: fix missing kernel-doc notation
has been removed from the -mm tree.  Its filename was
     pnp-fix-missing-kernel-doc-notation.patch

This patch was dropped because Bjorn's 'PNP: convert resource table to dynamic list, v1' patches made it obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: fix missing kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix missing PNP kernel-doc notation:

Warning(linux-2.6.25-git16//drivers/pnp/manager.c:261): No description found for parameter 'dev'
Warning(linux-2.6.25-git16//drivers/pnp/manager.c:292): No description found for parameter 'dev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/manager.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/manager.c~pnp-fix-missing-kernel-doc-notation drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-fix-missing-kernel-doc-notation
+++ a/drivers/pnp/manager.c
@@ -255,7 +255,7 @@ void pnp_init_resource(struct resource *
 
 /**
  * pnp_init_resources - Resets a resource table to default values.
- * @table: pointer to the desired resource table
+ * @dev: pointer to the owning &pnp_dev
  */
 void pnp_init_resources(struct pnp_dev *dev)
 {
@@ -286,7 +286,7 @@ void pnp_init_resources(struct pnp_dev *
 
 /**
  * pnp_clean_resources - clears resources that were not manually set
- * @res: the resources to clean
+ * @dev: &pnp_dev for the resources to clean
  */
 static void pnp_clean_resource_table(struct pnp_dev *dev)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
fix-gregkh-usb-usb-isp1760-hcd-driver.patch
uwb-fix-kconfig-causing-undefined-references.patch
uwb-fix-all-printk-format-warnings.patch
pnp-fix-missing-kernel-doc-notation.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch

