From: akpm@linux-foundation.org
Subject: - nuke-duplicate-include-from-printkc.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:44 -0800
Message-ID: <200802082016.m18KGPO1010712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42647 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbYBHUo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:44:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Nuke duplicate include from printk.c
has been removed from the -mm tree.  Its filename was
     nuke-duplicate-include-from-printkc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Nuke duplicate include from printk.c
From: Jesper Juhl <jesper.juhl@gmail.com>

Remove the duplicate inclusion of linux/jiffies.h from kernel/printk.c

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/printk.c~nuke-duplicate-include-from-printkc kernel/printk.c
--- a/kernel/printk.c~nuke-duplicate-include-from-printkc
+++ a/kernel/printk.c
@@ -32,7 +32,6 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
-#include <linux/jiffies.h>
 
 #include <asm/uaccess.h>
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
