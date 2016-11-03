From: akpm@linux-foundation.org
Subject: + compiler-gcch-use-proved-instead-of-proofed.patch added to -mm
 tree
Date: Thu, 03 Nov 2016 13:55:37 -0700
Message-ID: <581ba449.XJcFcfrATFRNV8sG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55570 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbcKCUzi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Nov 2016 16:55:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@benjamin.pe, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc.h: use "proved" instead of "proofed"
has been added to the -mm tree.  Its filename is
     compiler-gcch-use-proved-instead-of-proofed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/compiler-gcch-use-proved-instead-of-proofed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/compiler-gcch-use-proved-instead-of-proofed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from bp@benjamin.pe are

compiler-gcch-use-proved-instead-of-proofed.patch

