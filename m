From: akpm@linux-foundation.org
Subject: - provide-rtc_cmos-platform-device-take-2-fix.patch removed from -mm tree
Date: Thu, 12 Jun 2008 14:23:02 -0700
Message-ID: <200806122134.m5CLYiet007829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbYFLVfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 17:35:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stsp@aknet.ru, mm-commits@vger.kernel.org


The patch titled
     provide-rtc_cmos-platform-device-take-2 fix
has been removed from the -mm tree.  Its filename was
     provide-rtc_cmos-platform-device-take-2-fix.patch

This patch was dropped because it was folded into provide-rtc_cmos-platform-device-take-2.patch

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
linux-next.patch

