From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps-fix.patch added to -mm tree
Date: Thu, 20 Aug 2015 16:40:54 -0700
Message-ID: <55d66586.0hx6UZWASURZ3wP5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbbHTXkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Aug 2015 19:40:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/filesystems/proc.txt: give additional comment about hugetlb usage
has been added to the -mm tree.  Its filename is
     mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Documentation/filesystems/proc.txt: give additional comment about hugetlb usage

Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps-fix
+++ a/Documentation/filesystems/proc.txt
@@ -457,7 +457,8 @@ anonymous copy.
 
 "AnonHugePages" shows the ammount of memory backed by transparent hugepage.
 
-"HugetlbPages" shows the ammount of memory backed by hugetlbfs page.
+"HugetlbPages" shows the ammount of memory backed by hugetlbfs page (which is
+not counted in "Rss" or "Pss" field for historical reasons.)
 
 "Swap" shows how much would-be-anonymous memory is also used, but out on
 swap.  SwapPss" shows proportional swap share of this mapping.
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps-fix.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5.patch
mm-hwpoison-introduce-num_poisoned_pages-wrappers.patch
mm-hwpoison-dont-try-to-unpoison-containment-failed-pages.patch

