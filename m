From: akpm@linux-foundation.org
Subject: + mm-hwpoison-remove-obsolete-notebook-todo-list.patch added to
 -mm tree
Date: Tue, 21 Apr 2015 15:26:20 -0700
Message-ID: <5536ce8c./pS4raNY+ZQF19E0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbbDUW0U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Apr 2015 18:26:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: remove obsolete "Notebook" todo list
has been added to the -mm tree.  Its filename is
     mm-hwpoison-remove-obsolete-notebook-todo-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-remove-obsolete-notebook-todo-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-remove-obsolete-notebook-todo-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -35,13 +35,6 @@
  * are rare we hope to get away with this. This avoids impacting the core 
  * VM.
  */
