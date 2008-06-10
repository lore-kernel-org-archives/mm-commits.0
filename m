From: akpm@linux-foundation.org
Subject: + include-linux-aioh-removed-duplicated-include.patch added to -mm tree
Date: Tue, 10 Jun 2008 11:52:29 -0700
Message-ID: <200806101852.m5AIqTqx024105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757356AbYFJSwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 14:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com, bcrl@kvack.org


The patch titled
     include/linux/aio.h: removed duplicated include
has been added to the -mm tree.  Its filename is
     include-linux-aioh-removed-duplicated-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
include-linux-aioh-removed-duplicated-include.patch

