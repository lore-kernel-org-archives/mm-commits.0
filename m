From: akpm@linux-foundation.org
Subject: [folded-merged] mm-fix-checkpatch-warning-extraneous-braces.patch removed from -mm tree
Date: Thu, 02 Feb 2017 15:19:33 -0800
Message-ID: <5893be85.WodZ6t0MNzAEcpOw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33086 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbdBBXTd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 18:19:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@tobin.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Fix checkpatch warning, extraneous braces
has been removed from the -mm tree.  Its filename was
     mm-fix-checkpatch-warning-extraneous-braces.patch

This patch was dropped because it was folded into mm-fix-checkpatch-warnings-whitespace.patch

------------------------------------------------------
From: Tobin C Harding <me@tobin.cc>
Subject: mm: Fix checkpatch warning, extraneous braces

Patch fixes checkpatch warning on use of braces around a single
statement.

Link: http://lkml.kernel.org/r/1485992240-10986-5-git-send-email-me@tobin.cc
Signed-off-by: Tobin C Harding <me@tobin.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memory.c~mm-fix-checkpatch-warning-extraneous-braces mm/memory.c
--- a/mm/memory.c~mm-fix-checkpatch-warning-extraneous-braces
+++ a/mm/memory.c
@@ -1140,9 +1140,8 @@ again:
 	arch_enter_lazy_mmu_mode();
 	do {
 		pte_t ptent = *pte;
-		if (pte_none(ptent)) {
+		if (pte_none(ptent))
 			continue;
-		}
 
 		if (pte_present(ptent)) {
 			struct page *page;
_

Patches currently in -mm which might be from me@tobin.cc are

mm-fix-sparse-use-plain-integer-as-null-pointer.patch
mm-fix-checkpatch-warnings-whitespace.patch

