From: akpm@linux-foundation.org
Subject: [patch 101/123] compiler-gcc.h: use "proved" instead of "proofed"
Date: Mon, 12 Dec 2016 16:45:38 -0800
Message-ID: <584f44b2.DoFIK8isWDhu+JYB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbcLMApj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, bp@benjamin.pe

From: Benjamin Peterson <bp@benjamin.pe>
Subject: compiler-gcc.h: use "proved" instead of "proofed"

Link: http://lkml.kernel.org/r/1477894241.1103202.772260161.1B0A5995@webmail.messagingengine.com
Signed-off-by: Benjamin Peterson <bp@benjamin.pe>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc.h~compiler-gcch-use-proved-instead-of-proofed include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compiler-gcch-use-proved-instead-of-proofed
+++ a/include/linux/compiler-gcc.h
@@ -21,7 +21,7 @@
  * clobbered. The issue is as follows: while the inline asm might
  * access any memory it wants, the compiler could have fit all of
  * @ptr into memory registers instead, and since @ptr never escaped
- * from that, it proofed that the inline asm wasn't touching any of
+ * from that, it proved that the inline asm wasn't touching any of
  * it. This version works well with both compilers, i.e. we're telling
  * the compiler that the inline asm absolutely may see the contents
  * of @ptr. See also: https://llvm.org/bugs/show_bug.cgi?id=15495
_
