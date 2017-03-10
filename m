From: akpm@linux-foundation.org
Subject: [patch 13/26] drivers/md/bcache/util.h: remove duplicate
 inclusion of blkdev.h
Date: Thu, 09 Mar 2017 16:17:03 -0800
Message-ID: <58c1f07f.OPkc+ObMEUeumqxj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51348 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754434AbdCJARF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 19:17:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, standby24x7@gmail.com, colyli@suse.de, kent.overstreet@gmail.com

From: Masanari Iida <standby24x7@gmail.com>
Subject: drivers/md/bcache/util.h: remove duplicate inclusion of blkdev.h

Link: http://lkml.kernel.org/r/20170226060230.11555-1-standby24x7@gmail.com
Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
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
 #include <linux/sched/clock.h>
 #include <linux/llist.h>
_
