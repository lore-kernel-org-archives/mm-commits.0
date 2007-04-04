From: akpm@linux-foundation.org
Subject: + fixed-build-error-on-zs-serial-driver.patch added to -mm tree
Date: Wed, 04 Apr 2007 16:53:11 -0700
Message-ID: <200704042353.l34NrBCV002422@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35042 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbXDDX4d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 19:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, macro@linux-mips.org, ralf@linux-mips.org


The patch titled
     Fix build error on zs serial driver
has been added to the -mm tree.  Its filename is
     fixed-build-error-on-zs-serial-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 deletion(-)

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

origin.patch
fixed-build-error-on-zs-serial-driver.patch
git-input.patch
git-mips.patch
