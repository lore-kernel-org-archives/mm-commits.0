Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CAC0C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Feb 2022 04:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiBWEGJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 23:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiBWEGJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 23:06:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC8066AE0
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 20:05:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28324B81E6E
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 04:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE07C340E7;
        Wed, 23 Feb 2022 04:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645589139;
        bh=jdobQNMXYfMGqHVUChaky0jT+NmSVAzWZreKd17e1SA=;
        h=Date:To:From:Subject:From;
        b=zZKDOJqtM0J5kGAasdZ1whbV3RJbO0XuAeFDZxcrD0epE3NoGPC5rRdltdltW90Ji
         wvoiYY3stJwv0+odu2cZtvVYKibmejSqT0e2E+igrvDBq3x+3+2QEMdNvsZkrWJ9gL
         Xowly+KSVdNbyKgWD3p9Gp/6fOBsd18YHSGTeXMo=
Date:   Tue, 22 Feb 2022 20:05:39 -0800
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        cl@linux.com, vbabka@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-slab-add-roman-as-reviewer-git-tree.patch added to -mm tree
Message-Id: <20220223040539.CDE07C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS, SLAB: add Roman as reviewer, git tree
has been added to the -mm tree.  Its filename is
     maintainers-slab-add-roman-as-reviewer-git-tree.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-slab-add-roman-as-reviewer-git-tree.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-slab-add-roman-as-reviewer-git-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: MAINTAINERS, SLAB: add Roman as reviewer, git tree

The slab code has an overlap with kmem accounting, where Roman has done a
lot of work recently and it would be useful to make sure he's CC'd on
patches that potentially affect it.  Thus add him as a reviewer for the
SLAB subsystem.

Also while at it, add the link to slab git tree.

Link: https://lkml.kernel.org/r/20220222103104.13241-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-slab-add-roman-as-reviewer-git-tree
+++ a/MAINTAINERS
@@ -17766,8 +17766,10 @@ M:	David Rientjes <rientjes@google.com>
 M:	Joonsoo Kim <iamjoonsoo.kim@lge.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Vlastimil Babka <vbabka@suse.cz>
+R:	Roman Gushchin <roman.gushchin@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
 F:	include/linux/sl?b*.h
 F:	mm/sl?b*
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

maintainers-slab-add-roman-as-reviewer-git-tree.patch

