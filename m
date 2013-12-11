From: akpm@linux-foundation.org
Subject: + drivers-block-kconfig-update-ram-block-device-module-name.patch added to -mm tree
Date: Tue, 10 Dec 2013 16:09:14 -0800
Message-ID: <52a7ad2a.Gzx1WNLX2/3IwDWY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3LKAJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 19:09:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, fabf@skynet.be

Subject: + drivers-block-kconfig-update-ram-block-device-module-name.patch added to -mm tree
To: fabf@skynet.be,rdunlap@infradead.org
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 16:09:14 -0800


The patch titled
     Subject: drivers/block/Kconfig: update RAM block device module name
has been added to the -mm tree.  Its filename is
     drivers-block-kconfig-update-ram-block-device-module-name.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-block-kconfig-update-ram-block-device-module-name.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-block-kconfig-update-ram-block-device-module-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

drivers-block-kconfig-update-ram-block-device-module-name.patch

