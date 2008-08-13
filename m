From: akpm@linux-foundation.org
Subject: - drivers-char-rtcc-removed-duplicated-include.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:53:07 -0700
Message-ID: <200808130853.m7D8r7bg008295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331AbYHMJB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:01:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/rtc.c: removed duplicated include
has been removed from the -mm tree.  Its filename was
     drivers-char-rtcc-removed-duplicated-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/rtc.c: removed duplicated include
From: Huang Weiyi <weiyi.huang@gmail.com>

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/rtc.c~drivers-char-rtcc-removed-duplicated-include drivers/char/rtc.c
--- a/drivers/char/rtc.c~drivers-char-rtcc-removed-duplicated-include
+++ a/drivers/char/rtc.c
@@ -78,7 +78,6 @@
 #include <linux/wait.h>
 #include <linux/bcd.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
 #include <linux/uaccess.h>
 
 #include <asm/current.h>
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

linux-next.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

