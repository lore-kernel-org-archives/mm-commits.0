From: akpm@linux-foundation.org
Subject: - sfc-remove-sub-minor-component-from-driver-version.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:27 -0700
Message-ID: <200805231859.m4NIxRmr004240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbYEWS7c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sfc: remove sub-minor component from driver version
has been removed from the -mm tree.  Its filename was
     sfc-remove-sub-minor-component-from-driver-version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sfc: remove sub-minor component from driver version
From: Ben Hutchings <bhutchings@solarflare.com>

This driver has diverged from the out-of-tree driver to which the version
number originally applied.  It should be identified primarily by kernel
version.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/net_driver.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/sfc/net_driver.h~sfc-remove-sub-minor-component-from-driver-version drivers/net/sfc/net_driver.h
--- a/drivers/net/sfc/net_driver.h~sfc-remove-sub-minor-component-from-driver-version
+++ a/drivers/net/sfc/net_driver.h
@@ -42,7 +42,7 @@
 #ifndef EFX_DRIVER_NAME
 #define EFX_DRIVER_NAME	"sfc"
 #endif
-#define EFX_DRIVER_VERSION	"2.2.0136"
+#define EFX_DRIVER_VERSION	"2.2"
 
 #ifdef EFX_ENABLE_DEBUG
 #define EFX_BUG_ON_PARANOID(x) BUG_ON(x)
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

git-net.patch

