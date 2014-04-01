From: akpm@linux-foundation.org
Subject: + madvise-correct-the-comment-of-madv_dodump-flag.patch added to
 -mm tree
Date: Tue, 01 Apr 2014 12:21:50 -0700
Message-ID: <533b11ce.6YcqTAHEX6IJ0ryG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaDATVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2014 15:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com

Subject: + madvise-correct-the-comment-of-madv_dodump-flag.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 01 Apr 2014 12:21:50 -0700


The patch titled
     Subject: madvise: correct the comment of MADV_DODUMP flag
has been added to the -mm tree.  Its filename is
     madvise-correct-the-comment-of-madv_dodump-flag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/madvise-correct-the-comment-of-madv_dodump-flag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/madvise-correct-the-comment-of-madv_dodump-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: madvise: correct the comment of MADV_DODUMP flag

s/MADV_NODUMP/MADV_DONTDUMP/

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/asm-generic/mman-common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/uapi/asm-generic/mman-common.h~madvise-correct-the-comment-of-madv_dodump-flag include/uapi/asm-generic/mman-common.h
--- a/include/uapi/asm-generic/mman-common.h~madvise-correct-the-comment-of-madv_dodump-flag
+++ a/include/uapi/asm-generic/mman-common.h
@@ -50,7 +50,7 @@
 
 #define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
 					   overrides the coredump filter bits */
-#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+#define MADV_DODUMP	17		/* Clear the MADV_DONTDUMP flag */
 
 /* compatibility flags */
 #define MAP_FILE	0
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
madvise-correct-the-comment-of-madv_dodump-flag.patch

