From: akpm@linux-foundation.org
Subject: +
 fs-char_devc-fix-incorrect-documentation-for-unregister_chrdev_region.patch added to -mm tree
Date: Mon, 27 Jul 2015 16:15:19 -0700
Message-ID: <55b6bb87.Kqh6bQ9qxSXkmLqt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbbG0XPU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jul 2015 19:15:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ppm.floss@gmail.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/char_dev.c: fix incorrect documentation for unregister_chrdev_region
has been added to the -mm tree.  Its filename is
     fs-char_devc-fix-incorrect-documentation-for-unregister_chrdev_region.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-char_devc-fix-incorrect-documentation-for-unregister_chrdev_region.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-char_devc-fix-incorrect-documentation-for-unregister_chrdev_region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-char_devc-fix-incorrect-documentation-for-unregister_chrdev_region.patch

