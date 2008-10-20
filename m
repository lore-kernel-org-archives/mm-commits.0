From: akpm@linux-foundation.org
Subject: - arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:34 -0700
Message-ID: <200810202034.m9KKYYh3010881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558AbYJTUfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     arch/m68k/bvme6000/rtc.c: remove duplicated include
has been removed from the -mm tree.  Its filename was
     arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/m68k/bvme6000/rtc.c: remove duplicated include
From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated include file <linux/smp_lock.h> in
arch/m68k/bvme6000/rtc.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/bvme6000/rtc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/m68k/bvme6000/rtc.c~arch-m68k-bvme6000-rtcc-remove-duplicated-include arch/m68k/bvme6000/rtc.c
--- a/arch/m68k/bvme6000/rtc.c~arch-m68k-bvme6000-rtcc-remove-duplicated-include
+++ a/arch/m68k/bvme6000/rtc.c
@@ -18,7 +18,6 @@
 #include <linux/poll.h>
 #include <linux/module.h>
 #include <linux/mc146818rtc.h>	/* For struct rtc_time and ioctls, etc */
-#include <linux/smp_lock.h>
 #include <linux/bcd.h>
 #include <asm/bvme6000hw.h>
 
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

origin.patch
linux-next.patch

