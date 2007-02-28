From: akpm@linux-foundation.org
Subject: - spidernet-maintainership.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:53:11 -0800
Message-ID: <200702282353.l1SNrBM3031065@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48388 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621AbXB1Xxk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:53:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, Jens.Osterkamp@de.ibm.com, kou.ishizaki@toshiba.co.jp, mm-commits@vger.kernel.org


The patch titled
     spidernet: maintainership
has been removed from the -mm tree.  Its filename was
     spidernet-maintainership.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spidernet: maintainership
From: Linas Vepstas <linas@austin.ibm.com>

Update driver support contact info.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
Cc: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~spidernet-maintainership MAINTAINERS
--- a/MAINTAINERS~spidernet-maintainership
+++ a/MAINTAINERS
@@ -3186,8 +3186,8 @@ L:	linux-kernel@vger.kernel.org ?
 S:	Supported
 
 SPIDERNET NETWORK DRIVER for CELL
-P:	Jim Lewis
-M:	jim@jklewis.com
+P:	Linas Vepstas
+M:	linas@austin.ibm.com
 L:	netdev@vger.kernel.org
 S:	Supported
 
_

Patches currently in -mm which might be from linas@austin.ibm.com are

s2io-add-pci-error-recovery-support.patch
