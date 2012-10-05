From: akpm@linux-foundation.org
Subject: [merged] aoe-update-documentation-with-new-url-and-vm-settings-reference.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:47 -0700
Message-ID: <20121005202148.1992D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:56685 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:50 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so139146bkw.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: update documentation with new URL and VM settings reference
has been removed from the -mm tree.  Its filename was
     aoe-update-documentation-with-new-url-and-vm-settings-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: update documentation with new URL and VM settings reference

The old area has a new URL.  Also, now that the driver can perform better,
it is worth mentioning the VM settings that help aoe to sink dirty pages
out early, avoiding unecessary memory pressure when much I/O is going on.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/aoe/aoe.txt |    9 ++++++---
 MAINTAINERS               |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN Documentation/aoe/aoe.txt~aoe-update-documentation-with-new-url-and-vm-settings-reference Documentation/aoe/aoe.txt
--- a/Documentation/aoe/aoe.txt~aoe-update-documentation-with-new-url-and-vm-settings-reference
+++ a/Documentation/aoe/aoe.txt
@@ -1,8 +1,11 @@
-The EtherDrive (R) HOWTO for users of 2.6 kernels is found at ...
+The EtherDrive (R) HOWTO for 2.6 and 3.x kernels is found at ...
 
-  http://www.coraid.com/SUPPORT/EtherDrive-HBA  
+  http://support.coraid.com/support/linux/EtherDrive-2.6-HOWTO.html
 
-  It has many tips and hints!
+It has many tips and hints!  Please see, especially, recommended
+tunings for virtual memory:
+
+  http://support.coraid.com/support/linux/EtherDrive-2.6-HOWTO-5.html#ss5.19
 
 The aoetools are userland programs that are designed to work with this
 driver.  The aoetools are on sourceforge.
diff -puN MAINTAINERS~aoe-update-documentation-with-new-url-and-vm-settings-reference MAINTAINERS
--- a/MAINTAINERS~aoe-update-documentation-with-new-url-and-vm-settings-reference
+++ a/MAINTAINERS
@@ -1246,7 +1246,7 @@ F:	include/linux/i2c/at24.h
 
 ATA OVER ETHERNET (AOE) DRIVER
 M:	"Ed L. Cashin" <ecashin@coraid.com>
-W:	http://www.coraid.com/support/linux
+W:	http://support.coraid.com/support/linux
 S:	Supported
 F:	Documentation/aoe/
 F:	drivers/block/aoe/
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

