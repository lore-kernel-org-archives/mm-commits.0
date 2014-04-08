From: akpm@linux-foundation.org
Subject: [merged] asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:40:49 -0700
Message-ID: <53446ce1.rtmtUUK3jt+YbB9U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaDHVku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richard@nod.at, jdike@addtoit.com, arnd@arndb.de, dhowells@redhat.com

Subject: [merged] asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch removed from -mm tree
To: dhowells@redhat.com,arnd@arndb.de,jdike@addtoit.com,richard@nod.at,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:40:49 -0700


The patch titled
     Subject: asm/system.h: um: arch_align_stack() moved to asm/exec.h
has been removed from the -mm tree.  Its filename was
     asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: asm/system.h: um: arch_align_stack() moved to asm/exec.h

arch_align_stack() moved to asm/exec.h, so change the comment referring to
asm/system.h which no longer exists.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/kernel/process.c~asm-systemh-um-arch_align_stack-moved-to-asm-exech arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~asm-systemh-um-arch_align_stack-moved-to-asm-exech
+++ a/arch/um/kernel/process.c
@@ -359,7 +359,7 @@ int singlestepping(void * t)
 /*
  * Only x86 and x86_64 have an arch_align_stack().
  * All other arches have "#define arch_align_stack(x) (x)"
- * in their asm/system.h
+ * in their asm/exec.h
  * As this is included in UML from asm-um/system-generic.h,
  * we can use it to behave as the subarch does.
  */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch

