From: akpm@linux-foundation.org
Subject: [merged]
 fs-char_devc-fix-incorrect-documentation-for-unregister_chrdev_region.patch removed from -mm tree
Date: Fri, 07 Aug 2015 12:03:40 -0700
Message-ID: <55c5010c.vxgdV26mvXCdrysA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946135AbbHGTDk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 15:03:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ppm.floss@gmail.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/char_dev.c: fix incorrect documentation for unregister_chrdev_region
has been removed from the -mm tree.  Its filename was
     fs-char_devc-fix-incorrect-documentation-for-unregister_chrdev_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Partha Pratim Mukherjee <ppm.floss@gmail.com>
Subject: fs/char_dev.c: fix incorrect documentation for unregister_chrdev_region

The current documentation for unregister_chrdev_region says that it return
a range of device numbers which is incorrect.  Instead it unregister a
range of device numbers.  Fix the documentation to make this clear.

Signed-off-by: Partha Pratim Mukherjee <ppm.floss@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/char_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/char_dev.c~fs-char_devc-fix-incorrect-documentation-for-unregister_chrdev_region fs/char_dev.c
--- a/fs/char_dev.c~fs-char_devc-fix-incorrect-documentation-for-unregister_chrdev_region
+++ a/fs/char_dev.c
@@ -274,7 +274,7 @@ out2:
 }
 
 /**
- * unregister_chrdev_region() - return a range of device numbers
+ * unregister_chrdev_region() - unregister a range of device numbers
  * @from: the first in the range of numbers to unregister
  * @count: the number of device numbers to unregister
  *
_

Patches currently in -mm which might be from ppm.floss@gmail.com are

linux-next.patch

