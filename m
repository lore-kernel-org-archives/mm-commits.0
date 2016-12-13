From: akpm@linux-foundation.org
Subject: [folded-merged]
 init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch removed from
 -mm tree
Date: Mon, 12 Dec 2016 16:27:06 -0800
Message-ID: <584f405a.hCsBib6bhibQicSL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38858 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753199AbcLMA0W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:26:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, js07.lee@samsung.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: init-reduce-rootwait-polling-interval-time-to-5ms-fix
has been removed from the -mm tree.  Its filename was
     init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch

This patch was dropped because it was folded into init-reduce-rootwait-polling-interval-time-to-5ms.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init-reduce-rootwait-polling-interval-time-to-5ms-fix

remove used-once #define

Cc: Jungseung Lee <js07.lee@samsung.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN init/do_mounts.c~init-reduce-rootwait-polling-interval-time-to-5ms-fix init/do_mounts.c
--- a/init/do_mounts.c~init-reduce-rootwait-polling-interval-time-to-5ms-fix
+++ a/init/do_mounts.c
@@ -543,8 +543,6 @@ void __init mount_root(void)
 #endif
 }
 
-#define ROOTWAIT_MSEC 5
