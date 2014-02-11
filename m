From: akpm@linux-foundation.org
Subject: + drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch
 added to -mm tree
Date: Tue, 11 Feb 2014 12:26:07 -0800
Message-ID: <52fa875f.HAJyMp6KM7t2AwKz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386AbaBKU0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 15:26:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joro@8bytes.org, Hiroshi.DOYU@nokia.com, joe@perches.com

Subject: + drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch added to -mm tree
To: joe@perches.com,Hiroshi.DOYU@nokia.com,joro@8bytes.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 12:26:07 -0800


The patch titled
     Subject: drivers/iommu/omap-iommu-debug.c: fix decimal permissions
has been added to the -mm tree.  Its filename is
     drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: drivers/iommu/omap-iommu-debug.c: fix decimal permissions

These should have been octal

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
drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch
drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

