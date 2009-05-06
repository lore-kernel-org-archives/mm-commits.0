From: akpm@linux-foundation.org
Subject: [merged] x86-fix-a-typo-in-a-printk-message.patch removed from -mm tree
Date: Wed, 06 May 2009 13:47:30 -0700
Message-ID: <200905062047.n46KlUC2011102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760445AbZEFUuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2009 16:50:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: knikanth@suse.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86: fix a typo in a printk message
has been removed from the -mm tree.  Its filename was
     x86-fix-a-typo-in-a-printk-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix a typo in a printk message
From: Nikanth Karthikesan <knikanth@suse.de>

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/srat_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/srat_32.c~x86-fix-a-typo-in-a-printk-message arch/x86/mm/srat_32.c
--- a/arch/x86/mm/srat_32.c~x86-fix-a-typo-in-a-printk-message
+++ a/arch/x86/mm/srat_32.c
@@ -216,7 +216,7 @@ int __init get_memcfg_from_srat(void)
 
 	if (num_memory_chunks == 0) {
 		printk(KERN_WARNING
-			 "could not finy any ACPI SRAT memory areas.\n");
+			 "could not find any ACPI SRAT memory areas.\n");
 		goto out_fail;
 	}
 
_

Patches currently in -mm which might be from knikanth@suse.de are

linux-next.patch
block-prevent-possible-io_context-refcount-overflow.patch
atomic-detect-and-warn-on-atomic_inc-atomic_dec-wrapping-around.patch

