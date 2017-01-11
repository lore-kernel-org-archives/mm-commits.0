From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-remove-duplicite-bug-filling-description.patch removed from -mm tree
Date: Wed, 11 Jan 2017 14:27:34 -0800
Message-ID: <5876b156.xgdPhwct9x7hRg3r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbdAKW1f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 17:27:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove duplicate bug filling description
has been removed from the -mm tree.  Its filename was
     maintainers-remove-duplicite-bug-filling-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: MAINTAINERS: remove duplicate bug filling description

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

mm-page_alloc-dont-convert-pfn-to-idx-when-merging.patch
mm-page_alloc-avoid-page_to_pfn-when-merging-buddies.patch
mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key.patch

