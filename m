From: akpm@linux-foundation.org
Subject: [merged] microblaze-remove-unused-flat_stack_align-definition.patch removed from -mm tree
Date: Mon, 15 Jun 2009 12:01:39 -0700
Message-ID: <200906151901.n5FJ1dBM023014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756331AbZFOTBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 15:01:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.simek@petalogix.com, mm-commits@vger.kernel.org


The patch titled
     microblaze: remove unused flat_stack_align() definition
has been removed from the -mm tree.  Its filename was
     microblaze-remove-unused-flat_stack_align-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


