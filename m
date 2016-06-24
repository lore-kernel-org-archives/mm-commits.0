From: akpm@linux-foundation.org
Subject: [to-be-updated]
 s390-add-explicit-linux-stringifyh-for-jump-label.patch removed from -mm
 tree
Date: Fri, 24 Jun 2016 15:24:55 -0700
Message-ID: <576db337.THs+DVU3HUL52Cio%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbcFXWY4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 18:24:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, joe@perches.com, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390: add explicit <linux/stringify.h> for jump label
has been removed from the -mm tree.  Its filename was
     s390-add-explicit-linux-stringifyh-for-jump-label.patch

This patch was dropped because an updated version will be merged

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

dynamic_debug-add-jump-label-support.patch

