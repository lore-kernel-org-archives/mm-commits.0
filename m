From: akpm@linux-foundation.org
Subject: - include-linux-aioh-removed-duplicated-include.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:14:27 -0700
Message-ID: <200807262114.m6QLERXY019690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757544AbYGZVOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, bcrl@kvack.org, mm-commits@vger.kernel.org


The patch titled
     include/linux/aio.h: removed duplicated include
has been removed from the -mm tree.  Its filename was
     include-linux-aioh-removed-duplicated-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/aio.h: removed duplicated include
From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated include <linux/uio.h> in include/linux/aio.h

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/aio.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/aio.h~include-linux-aioh-removed-duplicated-include include/linux/aio.h
--- a/include/linux/aio.h~include-linux-aioh-removed-duplicated-include
+++ a/include/linux/aio.h
@@ -7,7 +7,6 @@
 #include <linux/uio.h>
 
 #include <asm/atomic.h>
-#include <linux/uio.h>
 
 #define AIO_MAXSEGS		4
 #define AIO_KIOGRP_NR_ATOMIC	8
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

origin.patch
linux-next.patch

