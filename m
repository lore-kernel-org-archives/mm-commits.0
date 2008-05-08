From: akpm@linux-foundation.org
Subject: - maintainers-new-maintainer-for-intel-ethernet-adapters.patch removed from -mm tree
Date: Thu, 08 May 2008 12:31:55 -0700
Message-ID: <200805081931.m48JVtQa001909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbYEHTcY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:32:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: auke-jan.h.kok@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: new maintainer for Intel ethernet adapters
has been removed from the -mm tree.  Its filename was
     maintainers-new-maintainer-for-intel-ethernet-adapters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: new maintainer for Intel ethernet adapters
From: Auke Kok <auke-jan.h.kok@intel.com>

I'm handing over maintainership to Jeff Kirsher and moving on to other
Linux/Open Source work within Intel.  Good luck to Jeff ;)

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~maintainers-new-maintainer-for-intel-ethernet-adapters MAINTAINERS
--- a/MAINTAINERS~maintainers-new-maintainer-for-intel-ethernet-adapters
+++ a/MAINTAINERS
@@ -2119,12 +2119,10 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 
 INTEL ETHERNET DRIVERS (e100/e1000/e1000e/igb/ixgb/ixgbe)
-P:	Auke Kok
-M:	auke-jan.h.kok@intel.com
-P:	Jesse Brandeburg
-M:	jesse.brandeburg@intel.com
 P:	Jeff Kirsher
 M:	jeffrey.t.kirsher@intel.com
+P:	Jesse Brandeburg
+M:	jesse.brandeburg@intel.com
 P:	Bruce Allan
 M:	bruce.w.allan@intel.com
 P:	John Ronciak
_

Patches currently in -mm which might be from auke-jan.h.kok@intel.com are

origin.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch

