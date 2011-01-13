From: akpm@linux-foundation.org
Subject: [merged] uml-mmapper_kern-needs-module_license.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:44 -0800
Message-ID: <201101132006.p0DK6PJS029745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757391Ab1AMUOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:14:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, glonnon@ridgerun.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: mmapper_kern needs MODULE_LICENSE
has been removed from the -mm tree.  Its filename was
     uml-mmapper_kern-needs-module_license.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: mmapper_kern needs MODULE_LICENSE
From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing MODULE_LICENSE():

WARNING: modpost: missing MODULE_LICENSE() in arch/um/drivers/mmapper_kern.o

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg Lonnon <glonnon@ridgerun.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mmapper_kern.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/drivers/mmapper_kern.c~uml-mmapper_kern-needs-module_license arch/um/drivers/mmapper_kern.c
--- a/arch/um/drivers/mmapper_kern.c~uml-mmapper_kern-needs-module_license
+++ a/arch/um/drivers/mmapper_kern.c
@@ -137,3 +137,4 @@ module_exit(mmapper_exit);
 
 MODULE_AUTHOR("Greg Lonnon <glonnon@ridgerun.com>");
 MODULE_DESCRIPTION("DSPLinux simulator mmapper driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
fs-fs_posix_acl-does-not-depend-on-block.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

