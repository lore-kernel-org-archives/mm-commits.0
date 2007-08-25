From: akpm@linux-foundation.org
Subject: - fix-jdelvare-i2c-i2c-at91-support-new-style-binding.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:24:23 -0700
Message-ID: <200708250324.l7P3ONOS028051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016AbXHYDYp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:24:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, david-b@pacbell.net, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     i2c-at91: compile fix (IS_ERR)
has been removed from the -mm tree.  Its filename was
     fix-jdelvare-i2c-i2c-at91-support-new-style-binding.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: i2c-at91: compile fix (IS_ERR)
From: Alexey Dobriyan <adobriyan@gmail.com>

  CC      drivers/i2c/busses/i2c-at91.o
drivers/i2c/busses/i2c-at91.c: In function 'at91_i2c_probe':
drivers/i2c/busses/i2c-at91.c:213: warning: implicit declaration of function 'IS_ERR'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-at91.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/i2c/busses/i2c-at91.c~fix-jdelvare-i2c-i2c-at91-support-new-style-binding drivers/i2c/busses/i2c-at91.c
--- a/drivers/i2c/busses/i2c-at91.c~fix-jdelvare-i2c-i2c-at91-support-new-style-binding
+++ a/drivers/i2c/busses/i2c-at91.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/delay.h>
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
nfs-fix-oops-re-sysctls-and-v4-support.patch
ifdef-struct-task_structsecurity.patch
faster-ext2_clear_inode.patch
fs-proc-mmuc-headers-butchery.patch
remove-sysctlh-from-fsh.patch
epcac-reformat-comments-and-coding-style-improvements.patch
shrink-struct-task_structoomkilladj.patch
remove-struct-task_structio_wait.patch
revert-faster-ext2_clear_inode.patch
