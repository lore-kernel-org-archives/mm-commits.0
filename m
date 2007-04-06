From: akpm@linux-foundation.org
Subject: - fixed-build-error-on-zs-serial-driver.patch removed from -mm tree
Date: Fri, 06 Apr 2007 13:08:44 -0700
Message-ID: <200704062008.l36K8iXa017870@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32929 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854AbXDFUMH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 16:12:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, macro@linux-mips.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Fix build error on zs serial driver
has been removed from the -mm tree.  Its filename was
     fixed-build-error-on-zs-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix build error on zs serial driver
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

drivers/tc/zs.c:73:24: error: asm/dec/tc.h: No such file or directory

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tc/zs.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/tc/zs.c~fixed-build-error-on-zs-serial-driver drivers/tc/zs.c
--- a/drivers/tc/zs.c~fixed-build-error-on-zs-serial-driver
+++ a/drivers/tc/zs.c
@@ -70,7 +70,6 @@
 #include <asm/dec/machtype.h>
 #include <asm/dec/serial.h>
 #include <asm/dec/system.h>
-#include <asm/dec/tc.h>
 
 #ifdef CONFIG_KGDB
 #include <asm/kgdb.h>
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

git-input.patch
git-mips.patch
