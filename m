From: akpm@linux-foundation.org
Subject: - sky2-118.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:16:46 -0700
Message-ID: <200709202116.l8KLGk5Z003034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47499 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbXITV2N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:13 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8KLSALj028068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 20 Sep 2007 14:28:12 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     sky2: 1.18
has been removed from the -mm tree.  Its filename was
     sky2-118.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sky2: 1.18
From: Stephen Hemminger <shemminger@linux-foundation.org>

Since there is new functionality (timestamping), increase the version.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/sky2.c~sky2-118 drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-118
+++ a/drivers/net/sky2.c
@@ -52,7 +52,7 @@
 #include "sky2.h"
 
 #define DRV_NAME		"sky2"
-#define DRV_VERSION		"1.17"
+#define DRV_VERSION		"1.18"
 #define PFX			DRV_NAME " "
 
 /*
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
git-infiniband.patch
git-input.patch
git-net.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
export-reciprocal_value-for-modules.patch
sky2-avoid-divide-in-receive-path.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
