From: akpm@linux-foundation.org
Subject: + microblaze-remove-unused-flat_stack_align-definition.patch added to -mm tree
Date: Mon, 01 Jun 2009 21:26:04 -0700
Message-ID: <200906020426.n524Q4tK002257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751108AbZFBE0b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 00:26:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.simek@petalogix.com


The patch titled
     microblaze: remove unused flat_stack_align() definition
has been added to the -mm tree.  Its filename is
     microblaze-remove-unused-flat_stack_align-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: microblaze: remove unused flat_stack_align() definition
From: Michal Simek <michal.simek@petalogix.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/flat.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/microblaze/include/asm/flat.h~microblaze-remove-unused-flat_stack_align-definition arch/microblaze/include/asm/flat.h
--- a/arch/microblaze/include/asm/flat.h~microblaze-remove-unused-flat_stack_align-definition
+++ a/arch/microblaze/include/asm/flat.h
@@ -13,7 +13,6 @@
 
 #include <asm/unaligned.h>
 
-#define	flat_stack_align(sp) /* nothing needed */
 #define	flat_argvp_envp_on_stack()	0
 #define	flat_old_ram_flag(flags)	(flags)
 #define	flat_reloc_valid(reloc, size)	((reloc) <= (size))
_

Patches currently in -mm which might be from michal.simek@petalogix.com are

microblaze-remove-unused-flat_stack_align-definition.patch

