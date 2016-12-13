From: akpm@linux-foundation.org
Subject: [patch 029/123] kmemleak: fix reference to Documentation
Date: Mon, 12 Dec 2016 16:42:01 -0800
Message-ID: <584f43d9.efpuCSF9rLd2i9pc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40792 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752544AbcLMAmD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:42:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, andreas.platschek@opentech.at, catalin.marinas@arm.com

From: Andreas Platschek <andreas.platschek@opentech.at>
Subject: kmemleak: fix reference to Documentation

Documentation/kmemleak.txt was moved to Documentation/dev-tools/kmemleak.rst,
this fixes the reference to the new location.

Link: http://lkml.kernel.org/r/1476544946-18804-1-git-send-email-andreas.platschek@opentech.at
Signed-off-by: Andreas Platschek <andreas.platschek@opentech.at>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kmemleak.c~kmemleak-fix-reference-to-documentation mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-fix-reference-to-documentation
+++ a/mm/kmemleak.c
@@ -19,7 +19,7 @@
  *
  *
  * For more information on the algorithm and kmemleak usage, please see
- * Documentation/kmemleak.txt.
+ * Documentation/dev-tools/kmemleak.rst.
  *
  * Notes on locking
  * ----------------
_
