From: akpm@linux-foundation.org
Subject: + arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch added to -mm tree
Date: Mon, 28 Jul 2008 21:47:41 -0700
Message-ID: <200807290447.m6T4lfOq014770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbYG2Erw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 00:47:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com, geert@linux-m68k.org


The patch titled
     arch/m68k/bvme6000/rtc.c: remove duplicated include
has been added to the -mm tree.  Its filename is
     arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

