From: akpm@linux-foundation.org
Subject: - cris-build-fixes-atomich-needs-compilerh.patch removed from -mm tree
Date: Mon, 03 Dec 2007 09:20:03 -0800
Message-ID: <200712031720.lB3HK3Og009291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbXLCRUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 12:20:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris build fixes: atomic.h needs compiler.h
has been removed from the -mm tree.  Its filename was
     cris-build-fixes-atomich-needs-compilerh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris build fixes: atomic.h needs compiler.h
From: Jesper Nilsson <jesper.nilsson@axis.com>

Include file linux/compiler.h is needed for 'likely'.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/atomic.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-cris/atomic.h~cris-build-fixes-atomich-needs-compilerh include/asm-cris/atomic.h
--- a/include/asm-cris/atomic.h~cris-build-fixes-atomich-needs-compilerh
+++ a/include/asm-cris/atomic.h
@@ -7,6 +7,7 @@
 
 #include <asm/system.h>
 #include <asm/arch/atomic.h>
+#include <linux/compiler.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
cris-avoid-using-arch-links-in-kconfig.patch
