From: akpm@linux-foundation.org
Subject: - parisc-fix-incomplete-header-guard.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:27:32 -0700
Message-ID: <200807292027.m6TKRWVx019664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759489AbYG2U1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 16:27:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     parisc: fix incomplete header guard
has been removed from the -mm tree.  Its filename was
     parisc-fix-incomplete-header-guard.patch

This patch was dropped because psw.h has vanished

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parisc: fix incomplete header guard
From: Vegard Nossum <vegard.nossum@gmail.com>

Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-parisc/psw.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-parisc/psw.h~parisc-fix-incomplete-header-guard include/asm-parisc/psw.h
--- a/include/asm-parisc/psw.h~parisc-fix-incomplete-header-guard
+++ a/include/asm-parisc/psw.h
@@ -1,5 +1,5 @@
 #ifndef _PARISC_PSW_H
