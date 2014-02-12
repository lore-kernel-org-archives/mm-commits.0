From: akpm@linux-foundation.org
Subject: + asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch added
 to -mm tree
Date: Wed, 12 Feb 2014 12:59:47 -0800
Message-ID: <52fbe0c3.dltBDVoKwiX3iHuw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaBLU7s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Feb 2014 15:59:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richard@nod.at, jdike@addtoit.com, arnd@arndb.de, dhowells@redhat.com

Subject: + asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch added to -mm tree
To: dhowells@redhat.com,arnd@arndb.de,jdike@addtoit.com,richard@nod.at
From: akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 12:59:47 -0800


The patch titled
     Subject: asm/system.h: um: arch_align_stack() moved to asm/exec.h
has been added to the -mm tree.  Its filename is
     asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
fs-cachefiles-use-add_to_page_cache_lru.patch
asm-systemh-clean-asm-systemh-from-docs.patch
asm-systemh-sparc-sparc_cpu_model-isnt-in-asm-systemh-any-more.patch
asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch
asm-systemh-arm-delete-asm-systemh.patch
linux-next.patch
mutex-subsystem-synchro-test-module.patch

