From: akpm@linux-foundation.org
Subject: [merged]
 drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch removed from
 -mm tree
Date: Thu, 27 Feb 2014 12:23:46 -0800
Message-ID: <530f9ed2.RJgkvOwvL5oxagHN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaB0UXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 15:23:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joro@8bytes.org, Hiroshi.DOYU@nokia.com, joe@perches.com

Subject: [merged] drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch removed from -mm tree
To: joe@perches.com,Hiroshi.DOYU@nokia.com,joro@8bytes.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 12:23:46 -0800


The patch titled
     Subject: drivers/iommu/omap-iommu-debug.c: fix decimal permissions
has been removed from the -mm tree.  Its filename was
     drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: drivers/iommu/omap-iommu-debug.c: fix decimal permissions

These should have been octal.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/omap-iommu-debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/iommu/omap-iommu-debug.c~drivers-iommu-omap-iommu-debugc-fix-decimal-permissions drivers/iommu/omap-iommu-debug.c
--- a/drivers/iommu/omap-iommu-debug.c~drivers-iommu-omap-iommu-debugc-fix-decimal-permissions
+++ a/drivers/iommu/omap-iommu-debug.c
@@ -354,8 +354,8 @@ DEBUG_FOPS(mem);
 			return -ENOMEM;					\
 	}
 
-#define DEBUG_ADD_FILE(name) __DEBUG_ADD_FILE(name, 600)
-#define DEBUG_ADD_FILE_RO(name) __DEBUG_ADD_FILE(name, 400)
+#define DEBUG_ADD_FILE(name) __DEBUG_ADD_FILE(name, 0600)
+#define DEBUG_ADD_FILE_RO(name) __DEBUG_ADD_FILE(name, 0400)
 
 static int iommu_debug_register(struct device *dev, void *data)
 {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-use-tab-for-separator.patch
maintainers-add-and-correct-types-of-some-t-entries.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
checkpatch-use-a-more-consistent-function-argument-style.patch
checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

