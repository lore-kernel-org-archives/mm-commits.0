Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D59C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 00:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbiB1At2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 19:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiB1At1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 19:49:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CEA3DDCC
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 16:48:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59EC96120D
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 00:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8CCC340E9;
        Mon, 28 Feb 2022 00:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646009328;
        bh=fag5/px5ZDYZW8sD0H2N3DUPN8fMqs9hPscZ5HP9GYU=;
        h=Date:To:From:Subject:From;
        b=fr5OhQNEJc5V9nA4lJouR475p/R+/FYCrcfyTiN895zb6wb097Y4JO/ASJPWbChb9
         72pvYMbIViT0S9nOWYOdEq6fAkMujWJTVTc5g20hJlqf8dfcdF5UhwAPf7rmYx87yS
         /fbO5hnXFys+aMCY4pFVpMz+feR2bkCveZkWCM18=
Date:   Sun, 27 Feb 2022 16:48:48 -0800
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        cl@linux.com, vbabka@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] maintainers-slab-add-roman-as-reviewer-git-tree.patch removed from -mm tree
Message-Id: <20220228004848.AB8CCC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS, SLAB: add Roman as reviewer, git tree
has been removed from the -mm tree.  Its filename was
     maintainers-slab-add-roman-as-reviewer-git-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -17762,8 +17762,10 @@ M:	David Rientjes <rientjes@google.com>
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


