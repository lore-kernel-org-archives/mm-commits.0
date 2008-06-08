From: akpm@linux-foundation.org
Subject: - h8300-fix-typo-in-header-guard.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:47 -0700
Message-ID: <200806081948.m58JmlUK017534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384AbYFHTs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300: fix typo in header guard
has been removed from the -mm tree.  Its filename was
     h8300-fix-typo-in-header-guard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: fix typo in header guard
From: Vegard Nossum <vegard.nossum@gmail.com>

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-h8300/cacheflush.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-h8300/cacheflush.h~h8300-fix-typo-in-header-guard include/asm-h8300/cacheflush.h
--- a/include/asm-h8300/cacheflush.h~h8300-fix-typo-in-header-guard
+++ a/include/asm-h8300/cacheflush.h
@@ -3,7 +3,7 @@
  */
 
 #ifndef _ASM_H8300_CACHEFLUSH_H
-#define _AMS_H8300_CACHEFLUSH_H
+#define _ASM_H8300_CACHEFLUSH_H
 
 /*
  * Cache handling functions
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
linux-next.patch
arm-fix-header-guards.patch
parisc-fix-incomplete-header-guard.patch
kallsyms-fix-potential-overflow-in-binary-search.patch
cputopology-always-define-cpu-topology-information.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
quota-cleanup-loop-in-sync_dquots.patch

