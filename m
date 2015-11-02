From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-dont-split-thp-page-when-syscall-is-called-fix.patch removed from -mm
 tree
Date: Mon, 02 Nov 2015 14:50:55 -0800
Message-ID: <5637e8cf.BHptZPC2aVpxyMsO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbbKBWu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 17:50:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pebolle@tiscali.nl, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Fix comment typo "CONFIG_TRANSPARNTE_HUGE"
has been removed from the -mm tree.  Its filename was
     mm-dont-split-thp-page-when-syscall-is-called-fix.patch

This patch was dropped because it was folded into mm-dont-split-thp-page-when-syscall-is-called.patch

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: mm: Fix comment typo "CONFIG_TRANSPARNTE_HUGE"

The commit "mm: don't split THP page when syscall is called" added a
reference to CONFIG_TRANSPARNTE_HUGE in a comment.  Use
CONFIG_TRANSPARENT_HUGEPAGE instead, as was probably intended.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-dont-split-thp-page-when-syscall-is-called-fix mm/rmap.c
--- a/mm/rmap.c~mm-dont-split-thp-page-when-syscall-is-called-fix
+++ a/mm/rmap.c
@@ -838,7 +838,7 @@ static int page_referenced_one(struct pa
 		/*
 		 * Use pmd_freeable instead of raw pmd_dirty because in some
 		 * of architecture, pmd_dirty is not defined unless
-		 * CONFIG_TRANSPARNTE_HUGE is enabled
+		 * CONFIG_TRANSPARENT_HUGEPAGE is enabled
 		 */
 		if (!pmd_freeable(*pmd))
 			dirty++;
_

Patches currently in -mm which might be from pebolle@tiscali.nl are

mm-dont-split-thp-page-when-syscall-is-called.patch

