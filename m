From: akpm@linux-foundation.org
Subject: [merged]
 lib-correct-link-to-the-original-source-for-div64_u64.patch removed from
 -mm tree
Date: Wed, 11 Mar 2015 12:17:49 -0700
Message-ID: <550094dd.49Dfj5ZSb3CIuLYn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbbCKTRt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 15:17:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/div64.c: correct link to the original source for div64_u64
has been removed from the -mm tree.  Its filename was
     lib-correct-link-to-the-original-source-for-div64_u64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: lib/div64.c: correct link to the original source for div64_u64

The code refers to an invalid url
http://www.hackersdelight.org/HDcode/newCode/divDouble.c.txt

The correct url is
http://www.hackersdelight.org/hdcodetxt/divDouble.c.txt

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/div64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/div64.c~lib-correct-link-to-the-original-source-for-div64_u64 lib/div64.c
--- a/lib/div64.c~lib-correct-link-to-the-original-source-for-div64_u64
+++ a/lib/div64.c
@@ -127,7 +127,7 @@ EXPORT_SYMBOL(div64_u64_rem);
  * by the book 'Hacker's Delight'.  The original source and full proof
  * can be found here and is available for use without restriction.
  *
- * 'http://www.hackersdelight.org/HDcode/newCode/divDouble.c.txt'
+ * 'http://www.hackersdelight.org/hdcodetxt/divDouble.c.txt'
  */
 #ifndef div64_u64
 u64 div64_u64(u64 dividend, u64 divisor)
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

linux-next.patch

