From: akpm@linux-foundation.org
Subject: + spidernet-maintainership.patch added to -mm tree
Date: Sun, 25 Feb 2007 05:01:57 -0800
Message-ID: <200702251301.l1PD1xm6029848@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35639 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964915AbXBYNCj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 08:02:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, Jens.Osterkamp@de.ibm.com, kou.ishizaki@toshiba.co.jp


The patch titled
     spidernet: maintainership
has been added to the -mm tree.  Its filename is
     spidernet-maintainership.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
sungem_phy-support-bcm5461-phy-autoneg.patch
spidernet-compile-break.patch
spidernet-autoneg-support-for-celleb.patch
spidernet-load-firmware-when-open.patch
spidernet-spidernet-add-support-for-celleb.patch
spidernet-remove-txram-full-logging.patch
spidernet-move-medium-variable-into-card-struct.patch
spidernet-separate-hardware-state-from-driver-state.patch
spidernet-fix-racy-double-free-of-skb.patch
spidernet-transmit-race.patch
spidernet-janitorial-typos.patch
spidernet-maintainership.patch
