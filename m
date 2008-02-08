From: akpm@linux-foundation.org
Subject: - nuke-duplicate-header-from-sysctlc.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:48 -0800
Message-ID: <200802082016.m18KGTYm010718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923AbYBHUof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:44:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Nuke duplicate header from sysctl.c
has been removed from the -mm tree.  Its filename was
     nuke-duplicate-header-from-sysctlc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Nuke duplicate header from sysctl.c
From: Jesper Juhl <jesper.juhl@gmail.com>

Don't include linux/security.h twice in kernel/sysctl.c

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/sysctl.c~nuke-duplicate-header-from-sysctlc kernel/sysctl.c
--- a/kernel/sysctl.c~nuke-duplicate-header-from-sysctlc
+++ a/kernel/sysctl.c
@@ -37,7 +37,6 @@
 #include <linux/highuid.h>
 #include <linux/writeback.h>
 #include <linux/hugetlb.h>
-#include <linux/security.h>
 #include <linux/initrd.h>
 #include <linux/times.h>
 #include <linux/limits.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
