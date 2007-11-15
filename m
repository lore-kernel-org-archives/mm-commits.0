From: akpm@linux-foundation.org
Subject: - cris-build-fixes-setupc-needs-paramh.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:52 -0800
Message-ID: <200711152111.lAFLBq3b015802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760054AbXKOVRA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris build fixes: setup.c needs param.h
has been removed from the -mm tree.  Its filename was
     cris-build-fixes-setupc-needs-paramh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris build fixes: setup.c needs param.h
From: Jesper Nilsson <jesper.nilsson@axis.com>

Include linux/param.h for HZ.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/setup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/cris/arch-v10/kernel/setup.c~cris-build-fixes-setupc-needs-paramh arch/cris/arch-v10/kernel/setup.c
--- a/arch/cris/arch-v10/kernel/setup.c~cris-build-fixes-setupc-needs-paramh
+++ a/arch/cris/arch-v10/kernel/setup.c
@@ -13,6 +13,7 @@
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
 #include <linux/delay.h>
+#include <linux/param.h>
 
 #ifdef CONFIG_PROC_FS
 #define HAS_FPU		0x0001
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
