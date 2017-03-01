From: akpm@linux-foundation.org
Subject: + bcache-remove-duplicate-inclusion-of-blkdevh.patch added to -mm tree
Date: Tue, 28 Feb 2017 16:10:45 -0800
Message-ID: <58b61185.8wmWx5j4CFle9OFf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39236 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751775AbdCADfz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 22:35:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, colyli@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/md/bcache/util.h: remove duplicate inclusion of blkdev.h
has been added to the -mm tree.  Its filename is
     bcache-remove-duplicate-inclusion-of-blkdevh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bcache-remove-duplicate-inclusion-of-blkdevh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bcache-remove-duplicate-inclusion-of-blkdevh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masanari Iida <standby24x7@gmail.com>
Subject: drivers/md/bcache/util.h: remove duplicate inclusion of blkdev.h

Link: http://lkml.kernel.org/r/20170226060230.11555-1-standby24x7@gmail.com
Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Coly Li <colyli@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/util.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/md/bcache/util.h~bcache-remove-duplicate-inclusion-of-blkdevh drivers/md/bcache/util.h
--- a/drivers/md/bcache/util.h~bcache-remove-duplicate-inclusion-of-blkdevh
+++ a/drivers/md/bcache/util.h
@@ -4,7 +4,6 @@
 
 #include <linux/blkdev.h>
 #include <linux/errno.h>
-#include <linux/blkdev.h>
 #include <linux/kernel.h>
 #include <linux/llist.h>
 #include <linux/ratelimit.h>
_

Patches currently in -mm which might be from standby24x7@gmail.com are

bcache-remove-duplicate-inclusion-of-blkdevh.patch

