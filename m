From: akpm@linux-foundation.org
Subject: [to-be-updated]
 powerpc-add-explicit-include-asm-asm-compath-for-jump-label.patch removed
 from -mm tree
Date: Fri, 24 Jun 2016 15:24:52 -0700
Message-ID: <576db334.iJOA0SA3cKRXCnq3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbcFXWYx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 18:24:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, joe@perches.com, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add explicit #include <asm/asm-compat.h> for jump label
has been removed from the -mm tree.  Its filename was
     powerpc-add-explicit-include-asm-asm-compath-for-jump-label.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jason Baron <jbaron@akamai.com>
Subject: powerpc: add explicit #include <asm/asm-compat.h> for jump label

The stringify_in_c() macro may not be included. Make the dependency
explicit.

Link: http://lkml.kernel.org/r/a71251966e052e4e494957c313af02f1d9fd6ce6.1463778029.git.jbaron@akamai.com
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

 arch/powerpc/include/asm/jump_label.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/include/asm/jump_label.h~powerpc-add-explicit-include-asm-asm-compath-for-jump-label arch/powerpc/include/asm/jump_label.h
--- a/arch/powerpc/include/asm/jump_label.h~powerpc-add-explicit-include-asm-asm-compath-for-jump-label
+++ a/arch/powerpc/include/asm/jump_label.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 
 #include <asm/feature-fixups.h>
+#include <asm/asm-compat.h>
 
 #define JUMP_ENTRY_TYPE		stringify_in_c(FTR_ENTRY_LONG)
 #define JUMP_LABEL_NOP_SIZE	4
_

Patches currently in -mm which might be from jbaron@akamai.com are

s390-add-explicit-linux-stringifyh-for-jump-label.patch
dynamic_debug-add-jump-label-support.patch

