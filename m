From: akpm@linux-foundation.org
Subject: [merged] madvise-correct-the-comment-of-madv_dodump-flag.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:59:09 -0700
Message-ID: <5344631d.G8oE0k1KrRHgiyfi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHU7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:59:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] madvise-correct-the-comment-of-madv_dodump-flag.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:59:09 -0700


The patch titled
     Subject: madvise: correct the comment of MADV_DODUMP flag
has been removed from the -mm tree.  Its filename was
     madvise-correct-the-comment-of-madv_dodump-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

