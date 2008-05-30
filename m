From: akpm@linux-foundation.org
Subject: - mn10300-fix-typo-in-header-guard.patch removed from -mm tree
Date: Fri, 30 May 2008 15:38:25 -0700
Message-ID: <200805302238.m4UMcPW7014823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752466AbYE3Wjc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:39:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: fix typo in header guard
has been removed from the -mm tree.  Its filename was
     mn10300-fix-typo-in-header-guard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: fix typo in header guard
From: Vegard Nossum <vegard.nossum@gmail.com>

Fix a typo in the header guard of asm/ipc.h.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mn10300/ipcbuf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-mn10300/ipcbuf.h~mn10300-fix-typo-in-header-guard include/asm-mn10300/ipcbuf.h
--- a/include/asm-mn10300/ipcbuf.h~mn10300-fix-typo-in-header-guard
+++ a/include/asm-mn10300/ipcbuf.h
@@ -1,4 +1,4 @@
-#ifndef _ASM_IPCBUF_H_
+#ifndef _ASM_IPCBUF_H
 #define _ASM_IPCBUF_H
 
 /*
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
x86-fix-incomplete-include-guard.patch
arm-fix-header-guards.patch
parisc-fix-incomplete-header-guard.patch
h8300-fix-typo-in-header-guard.patch
v850-fix-typo-in-header-guard.patch
kallsyms-fix-potential-overflow-in-binary-search.patch

