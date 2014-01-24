From: akpm@linux-foundation.org
Subject: [merged]
 drivers-block-kconfig-update-ram-block-device-module-name.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 10:59:57 -0800
Message-ID: <52e2b82d.vxS4wa7njU510xoJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, fabf@skynet.be

Subject: [merged] drivers-block-kconfig-update-ram-block-device-module-name.patch removed from -mm tree
To: fabf@skynet.be,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:57 -0800


The patch titled
     Subject: drivers/block/Kconfig: update RAM block device module name
has been removed from the -mm tree.  Its filename was
     drivers-block-kconfig-update-ram-block-device-module-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: drivers/block/Kconfig: update RAM block device module name

RAM block device support module name changed to brd.ko some years ago with
an "rd" alias to match previous module implementation.  This patch updates
its Kconfig definition.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/block/Kconfig~drivers-block-kconfig-update-ram-block-device-module-name drivers/block/Kconfig
--- a/drivers/block/Kconfig~drivers-block-kconfig-update-ram-block-device-module-name
+++ a/drivers/block/Kconfig
@@ -368,7 +368,8 @@ config BLK_DEV_RAM
 	  For details, read <file:Documentation/blockdev/ramdisk.txt>.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called rd.
+	  module will be called brd. An alias "rd" has been defined
+	  for historical reasons.
 
 	  Most normal users won't need the RAM disk functionality, and can
 	  thus say N here.
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
ufs-sb-mutex-merge-mutex_destroy.patch

