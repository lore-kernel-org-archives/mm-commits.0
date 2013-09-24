From: akpm@linux-foundation.org
Subject: +
 documentation-kernel-parameterstxt-replace-kernelcore-with-movable.patch
 added to -mm tree
Date: Tue, 24 Sep 2013 15:54:07 -0700
Message-ID: <5242180f.vgf03Hx08wt3QAbk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3IXWyI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Sep 2013 18:54:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, mgorman@suse.de, wpan@redhat.com

Subject: + documentation-kernel-parameterstxt-replace-kernelcore-with-movable.patch added to -mm tree
To: wpan@redhat.com,mgorman@suse.de,rdunlap@infradead.org
From: akpm@linux-foundation.org
Date: Tue, 24 Sep 2013 15:54:07 -0700


The patch titled
     Subject: Documentation/kernel-parameters.txt: replace kernelcore with Movable
has been added to the -mm tree.  Its filename is
     documentation-kernel-parameterstxt-replace-kernelcore-with-movable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-kernel-parameterstxt-replace-kernelcore-with-movable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-kernel-parameterstxt-replace-kernelcore-with-movable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weiping Pan <wpan@redhat.com>
Subject: Documentation/kernel-parameters.txt: replace kernelcore with Movable

Han Pingtian found a typo in Documentation/kernel-parameters.txt about
"kernelcore=", that "kernelcore" should be replaced with "Movable" here.

Signed-off-by: Weiping Pan <wpan@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~documentation-kernel-parameterstxt-replace-kernelcore-with-movable Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~documentation-kernel-parameterstxt-replace-kernelcore-with-movable
+++ a/Documentation/kernel-parameters.txt
@@ -1357,7 +1357,7 @@ bytes respectively. Such letter suffixes
 			pages. In the event, a node is too small to have both
 			kernelcore and Movable pages, kernelcore pages will
 			take priority and other nodes will have a larger number
-			of kernelcore pages.  The Movable zone is used for the
+			of Movable pages.  The Movable zone is used for the
 			allocation of pages that may be reclaimed or moved
 			by the page migration subsystem.  This means that
 			HugeTLB pages may not be allocated from this zone.
_

Patches currently in -mm which might be from wpan@redhat.com are

documentation-kernel-parameterstxt-replace-kernelcore-with-movable.patch

