From: akpm@linux-foundation.org
Subject: - cris-build-fixes-hardirqh-include-asm-irqh.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:33 -0800
Message-ID: <200711152111.lAFLBXKQ015775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48380 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754913AbXKOVQ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:16:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris build fixes: hardirq.h: include asm/irq.h
has been removed from the -mm tree.  Its filename was
     cris-build-fixes-hardirqh-include-asm-irqh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris build fixes: hardirq.h: include asm/irq.h
From: Jesper Nilsson <jesper.nilsson@axis.com>

Include asm/irq.h to avoid undefined value warning.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/hardirq.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-cris/hardirq.h~cris-build-fixes-hardirqh-include-asm-irqh include/asm-cris/hardirq.h
--- a/include/asm-cris/hardirq.h~cris-build-fixes-hardirqh-include-asm-irqh
+++ a/include/asm-cris/hardirq.h
@@ -1,6 +1,7 @@
 #ifndef __ASM_HARDIRQ_H
 #define __ASM_HARDIRQ_H
 
+#include <asm/irq.h>
 #include <linux/threads.h>
 #include <linux/cache.h>
 
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
