From: akpm@linux-foundation.org
Subject: [merged] kmemleak-fix-reference-to-documentation.patch removed
 from -mm tree
Date: Wed, 14 Dec 2016 11:23:55 -0800
Message-ID: <58519c4b.XkdC6uFcCaJIvRq7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44066 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756518AbcLNTX4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:23:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.platschek@opentech.at, catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: fix reference to Documentation
has been removed from the -mm tree.  Its filename was
     kmemleak-fix-reference-to-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreas.platschek@opentech.at are

kconfig-lib-kconfigdebug-fix-references-to-documenation.patch
kconfig-lib-kconfigubsan-fix-reference-to-ubsan-documentation.patch

