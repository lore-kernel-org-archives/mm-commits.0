From: akpm@linux-foundation.org
Subject: + mm-remove-pg_highmem-description.patch added to -mm tree
Date: Wed, 31 Jan 2018 12:02:19 -0800
Message-ID: <5a7220cb.k0VTYSVMLdpMgA5V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36622 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751664AbeAaUCU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 15:02:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove PG_highmem description
has been added to the -mm tree.  Its filename is
     mm-remove-pg_highmem-description.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-pg_highmem-description.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-pg_highmem-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: mm: remove PG_highmem description

cbe37d093707 ("[PATCH] mm: remove PG_highmem") removed PG_highmem to save
a page flag.  So the description of PG_highmem is no longer needed.

Link: http://lkml.kernel.org/r/1517391212-2950-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/page-flags.h~mm-remove-pg_highmem-description include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-remove-pg_highmem-description
+++ a/include/linux/page-flags.h
@@ -46,11 +46,6 @@
  * guarantees that this bit is cleared for a page when it first is entered into
  * the page cache.
  *
- * PG_highmem pages are not permanently mapped into the kernel virtual address
- * space, they need to be kmapped separately for doing IO on the pages.  The
- * struct page (these bits with information) are always mapped into kernel
- * address space...
- *
  * PG_hwpoison indicates that a page got corrupted in hardware and contains
  * data with incorrect ECC bits that triggered a machine check. Accessing is
  * not safe since it may cause another machine check. Don't touch!
_

Patches currently in -mm which might be from miles.chen@mediatek.com are

slub-remove-obsolete-comments-of-put_cpu_partial.patch
mm-remove-pg_highmem-description.patch

