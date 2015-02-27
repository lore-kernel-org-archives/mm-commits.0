From: akpm@linux-foundation.org
Subject: + lib-correct-link-to-the-original-source-for-div64_u64.patch
 added to -mm tree
Date: Fri, 27 Feb 2015 15:03:59 -0800
Message-ID: <54f0f7df.T1X7kPUL0cuGSUHI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbbB0XEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 18:04:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/div64.c: correct link to the original source for div64_u64
has been added to the -mm tree.  Its filename is
     lib-correct-link-to-the-original-source-for-div64_u64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-correct-link-to-the-original-source-for-div64_u64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-correct-link-to-the-original-source-for-div64_u64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-correct-link-to-the-original-source-for-div64_u64.patch

