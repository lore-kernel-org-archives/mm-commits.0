From: akpm@linux-foundation.org
Subject: + s390-add-explicit-linux-stringifyh-for-jump-label.patch added
 to -mm tree
Date: Thu, 02 Jun 2016 16:30:00 -0700
Message-ID: <5750c178.av35m+wYmeE7X2rQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbcFBXaB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 19:30:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, joe@perches.com, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390: add explicit <linux/stringify.h> for jump label
has been added to the -mm tree.  Its filename is
     s390-add-explicit-linux-stringifyh-for-jump-label.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-add-explicit-linux-stringifyh-for-jump-label.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-add-explicit-linux-stringifyh-for-jump-label.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Baron <jbaron@akamai.com>
Subject: s390: add explicit <linux/stringify.h> for jump label

Ensure that we always have __stringify().

Link: http://lkml.kernel.org/r/f242f753b4c819b8da5351007d81ed055b4b8bdf.1463778029.git.jbaron@akamai.com
Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/jump_label.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/s390/include/asm/jump_label.h~s390-add-explicit-linux-stringifyh-for-jump-label arch/s390/include/asm/jump_label.h
--- a/arch/s390/include/asm/jump_label.h~s390-add-explicit-linux-stringifyh-for-jump-label
+++ a/arch/s390/include/asm/jump_label.h
@@ -4,6 +4,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
+#include <linux/stringify.h>
 
 #define JUMP_LABEL_NOP_SIZE 6
 #define JUMP_LABEL_NOP_OFFSET 2
_

Patches currently in -mm which might be from jbaron@akamai.com are

jump_label-remove-bugh-atomich-dependencies-for-have_jump_label.patch
powerpc-add-explicit-include-asm-asm-compath-for-jump-label.patch
s390-add-explicit-linux-stringifyh-for-jump-label.patch
dynamic_debug-add-jump-label-support.patch

