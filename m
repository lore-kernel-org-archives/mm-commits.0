From: akpm@linux-foundation.org
Subject: - cris-build-fixes-sys_crisc-needs-fsh.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:39 -0800
Message-ID: <200711152111.lAFLBdbB015784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759938AbXKOVQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris build fixes: sys_cris.c needs fs.h
has been removed from the -mm tree.  Its filename was
     cris-build-fixes-sys_crisc-needs-fsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris build fixes: sys_cris.c needs fs.h
From: Jesper Nilsson <jesper.nilsson@axis.com>

Include linux/fs.h, needed for do_pipe.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/kernel/sys_cris.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/cris/kernel/sys_cris.c~cris-build-fixes-sys_crisc-needs-fsh arch/cris/kernel/sys_cris.c
--- a/arch/cris/kernel/sys_cris.c~cris-build-fixes-sys_crisc-needs-fsh
+++ a/arch/cris/kernel/sys_cris.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
 #include <linux/sem.h>
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
