From: akpm@linux-foundation.org
Subject: - v850-fix-typo-in-header-guard.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:50 -0700
Message-ID: <200806081948.m58JmoHF017537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754317AbYFHTsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     v850: fix typo in header guard
has been removed from the -mm tree.  Its filename was
     v850-fix-typo-in-header-guard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v850: fix typo in header guard
From: Vegard Nossum <vegard.nossum@gmail.com>

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-v850/clinkage.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-v850/clinkage.h~v850-fix-typo-in-header-guard include/asm-v850/clinkage.h
--- a/include/asm-v850/clinkage.h~v850-fix-typo-in-header-guard
+++ a/include/asm-v850/clinkage.h
@@ -11,7 +11,7 @@
  * Written by Miles Bader <miles@gnu.org>
  */
 
-#ifndef __CLINKAGE_H__
+#ifndef __V850_CLINKAGE_H__
 #define __V850_CLINKAGE_H__
 
 #include <asm/macrology.h>
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

