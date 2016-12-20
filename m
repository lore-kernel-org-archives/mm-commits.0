From: akpm@linux-foundation.org
Subject: + maintainers-remove-duplicite-bug-filling-description.patch
 added to -mm tree
Date: Tue, 20 Dec 2016 15:26:35 -0800
Message-ID: <5859be2b.KhPFit5bHDxA+nSZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42330 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932479AbcLTXZd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2016 18:25:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove duplicite bug filling description
has been added to the -mm tree.  Its filename is
     maintainers-remove-duplicite-bug-filling-description.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-duplicite-bug-filling-description.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-duplicite-bug-filling-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: MAINTAINERS: remove duplicite bug filling description

I have noticed that two different descriptions for B: entries in MAINTAINERS
were merged: commit 686564434e88 ("MAINTAINERS: Add bug tracking system
location entry type") and 2de2bd95f456 ("MAINTAINERS: add "B:" for URI where
to file bugs").

This patch keeps the description from 2de2bd95f456. There has been a
discussion [1] about whether this more detailed description is useful and what
it exactly implies. I find it more useful and general, and the author of
686564434e88 agreed in the end that either is fine.

[1] https://lkml.org/lkml/2016/12/8/71

Link: http://lkml.kernel.org/r/20161219085158.12114-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-duplicite-bug-filling-description MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-duplicite-bug-filling-description
+++ a/MAINTAINERS
@@ -81,7 +81,6 @@ Descriptions of section entries:
 	Q: Patchwork web based patch tracking system site
 	T: SCM tree type and location.
 	   Type is one of: git, hg, quilt, stgit, topgit
-	B: Bug tracking system location.
 	S: Status, one of the following:
 	   Supported:	Someone is actually paid to look after this.
 	   Maintained:	Someone actually looks after it.
_

Patches currently in -mm which might be from vbabka@suse.cz are

maintainers-remove-duplicite-bug-filling-description.patch
mm-page_alloc-dont-convert-pfn-to-idx-when-merging.patch
mm-page_alloc-avoid-page_to_pfn-when-merging-buddies.patch
mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key.patch

