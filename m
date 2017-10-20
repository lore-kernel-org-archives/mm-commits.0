From: akpm@linux-foundation.org
Subject: + lib-int_sqrt-adjust-comments.patch added to -mm tree
Date: Fri, 20 Oct 2017 15:18:17 -0700
Message-ID: <59ea7629.cCzLOY3a2u4Qm/9y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59134 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752041AbdJTWSS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2017 18:18:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, aksgarg1989@gmail.com, davem@davemloft.net, dave@stgolabs.net, joe@perches.com, keescook@chromium.org, mawilcox@microsoft.com, md@google.com, mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/int_sqrt: adjust comments
has been added to the -mm tree.  Its filename is
     lib-int_sqrt-adjust-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-int_sqrt-adjust-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-int_sqrt-adjust-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: lib/int_sqrt: adjust comments

Our current int_sqrt() is not rough nor any approximation; it calculates
the exact value of: floor(sqrt()).  Document this.

Link: http://lkml.kernel.org/r/20171020164645.001652117@infradead.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anshul Garg <aksgarg1989@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Michael Davidson <md@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/int_sqrt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/int_sqrt.c~lib-int_sqrt-adjust-comments lib/int_sqrt.c
--- a/lib/int_sqrt.c~lib-int_sqrt-adjust-comments
+++ a/lib/int_sqrt.c
@@ -10,10 +10,10 @@
 #include <linux/bitops.h>
 
 /**
- * int_sqrt - rough approximation to sqrt
+ * int_sqrt - computes the integer square root
  * @x: integer of which to calculate the sqrt
  *
- * A very rough approximation to the sqrt() function.
+ * Computes: floor(sqrt(x))
  */
 unsigned long int_sqrt(unsigned long x)
 {
_

Patches currently in -mm which might be from peterz@infradead.org are

lib-int_sqrt-optimize-small-argument.patch
lib-int_sqrt-optimize-initial-value-compute.patch
lib-int_sqrt-adjust-comments.patch

