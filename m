From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-pxa3xx-nand-flash-driver-pattern.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:15 -0700
Message-ID: <53ea6e53.l2CnpEqXi+VmFSoK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34614 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbaHLTnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:16 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so1920929obc.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix PXA3xx NAND FLASH DRIVER pattern
has been removed from the -mm tree.  Its filename was
     maintainers-fix-pxa3xx-nand-flash-driver-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: fix PXA3xx NAND FLASH DRIVER pattern

Use underscore, not dash

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-pxa3xx-nand-flash-driver-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-pxa3xx-nand-flash-driver-pattern
+++ a/MAINTAINERS
@@ -7245,7 +7245,7 @@ PXA3xx NAND FLASH DRIVER
 M:	Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
-F:	drivers/mtd/nand/pxa3xx-nand.c
+F:	drivers/mtd/nand/pxa3xx_nand.c
 
 MMP SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

