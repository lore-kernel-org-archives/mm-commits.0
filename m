From: akpm@linux-foundation.org
Subject: + alpha-doesnt-use-socketcall.patch added to -mm tree
Date: Tue, 27 Nov 2007 14:47:50 -0800
Message-ID: <200711272247.lARMloOI003393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbXK0WsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 17:48:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@citrix.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     Alpha doesn't use socketcall
has been added to the -mm tree.  Its filename is
     alpha-doesnt-use-socketcall.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Alpha doesn't use socketcall
From: Samuel Thibault <samuel.thibault@citrix.com>

Alpha doesn't use socketcall and doesn't provide __NR_socketcall.

Signed-off-by: Samuel Thibault <samuel.thibault@citrix.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/unistd.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/asm-alpha/unistd.h~alpha-doesnt-use-socketcall include/asm-alpha/unistd.h
--- a/include/asm-alpha/unistd.h~alpha-doesnt-use-socketcall
+++ a/include/asm-alpha/unistd.h
@@ -442,7 +442,6 @@
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_GETHOSTNAME
-#define __ARCH_WANT_SYS_SOCKETCALL
 #define __ARCH_WANT_SYS_FADVISE64
 #define __ARCH_WANT_SYS_GETPGRP
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
_

Patches currently in -mm which might be from samuel.thibault@citrix.com are

alpha-doesnt-use-socketcall.patch
