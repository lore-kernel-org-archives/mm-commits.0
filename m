From: akpm@linux-foundation.org
Subject: + provide-rtc_cmos-platform-device-take-2-fix.patch added to -mm tree
Date: Thu, 05 Jun 2008 22:50:25 -0700
Message-ID: <200806060550.m565oPd3016209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439AbYFFFvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 01:51:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stsp@aknet.ru


The patch titled
     provide-rtc_cmos-platform-device-take-2 fix
has been added to the -mm tree.  Its filename is
     provide-rtc_cmos-platform-device-take-2-fix.patch

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
Subject: provide-rtc_cmos-platform-device-take-2 fix
From: Stas Sergeev <stsp@aknet.ru>

Fix include problem reported by checkpatch.pl

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/rtc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/kernel/rtc.c~provide-rtc_cmos-platform-device-take-2-fix arch/x86/kernel/rtc.c
--- a/arch/x86/kernel/rtc.c~provide-rtc_cmos-platform-device-take-2-fix
+++ a/arch/x86/kernel/rtc.c
@@ -9,7 +9,6 @@
 
 #include <asm/time.h>
 #include <asm/vsyscall.h>
-#include <asm/mc146818rtc.h>
 
 #ifdef CONFIG_X86_32
 /*
_

Patches currently in -mm which might be from stsp@aknet.ru are

provide-rtc_cmos-platform-device-take-2.patch
provide-rtc_cmos-platform-device-take-2-fix.patch

