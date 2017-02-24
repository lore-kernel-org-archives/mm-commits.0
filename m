From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte-v3.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:40:24 -0800
Message-ID: <58b0b658.c/kZNFhLoAi/ause%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34154 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbdBXWk0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:40:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mikey@neuling.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte-v3
has been removed from the -mm tree.  Its filename was
     mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte-v3.patch

This patch was dropped because it was folded into mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte-v3

Link: http://lkml.kernel.org/r/1487498625-10891-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte-v3 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte-v3
+++ a/mm/huge_memory.c
@@ -1426,7 +1426,7 @@ int do_huge_pmd_numa_page(struct vm_faul
 	}
 
 	/* See similar comment in do_numa_page for explanation */
-	if (!pmd_write(pmd))
+	if (!pmd_savedwrite(pmd))
 		flags |= TNF_NO_GROUP;
 
 	/*
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes.patch
mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch
mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte-v3-fix.patch
mm-ksm-handle-protnone-saved-writes-when-making-page-write-protect.patch
powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write.patch
powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3.patch
mm-gup-check-for-protnone-only-if-it-is-a-pte-entry.patch
mm-thp-autonuma-use-tnf-flag-instead-of-vm-fault.patch

