From: akpm@linux-foundation.org
Subject: [merged] fs-kdev_t-remove-unused-huge_valid_dev-function.patch
 removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:18 -0800
Message-ID: <5642548e.0Xe6LB1tjU9/JoRk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbKJUdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/kdev_t.h: remove unused huge_valid_dev()
has been removed from the -mm tree.  Its filename was
     fs-kdev_t-remove-unused-huge_valid_dev-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: include/linux/kdev_t.h: remove unused huge_valid_dev()

There's no user of huge_valid_dev() any more, so remove it.

No functional change.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kdev_t.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/kdev_t.h~fs-kdev_t-remove-unused-huge_valid_dev-function include/linux/kdev_t.h
--- a/include/linux/kdev_t.h~fs-kdev_t-remove-unused-huge_valid_dev-function
+++ a/include/linux/kdev_t.h
@@ -54,11 +54,6 @@ static inline dev_t new_decode_dev(u32 d
 	return MKDEV(major, minor);
 }
 
-static inline int huge_valid_dev(dev_t dev)
-{
-	return 1;
-}
