From: akpm@linux-foundation.org
Subject: [merged] mm-hwpoison-remove-obsolete-notebook-todo-list.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:37:21 -0700
Message-ID: <5591ac81.dm6viH1AHaIxeiMO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbbF2UhW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:37:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: remove obsolete "Notebook" todo list
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-remove-obsolete-notebook-todo-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: mm, hwpoison: remove obsolete "Notebook" todo list

All the items mentioned here have been either addressed, or were not
really needed.  So just remove the comment.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-remove-obsolete-notebook-todo-list mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-remove-obsolete-notebook-todo-list
+++ a/mm/memory-failure.c
@@ -36,13 +36,6 @@
  * are rare we hope to get away with this. This avoids impacting the core 
  * VM.
  */
