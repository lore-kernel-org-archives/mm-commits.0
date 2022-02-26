Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C00C5C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 26 Feb 2022 03:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiBZDL5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 22:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiBZDLz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 22:11:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AE72671E1
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 19:11:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E889861E2C
        for <mm-commits@vger.kernel.org>; Sat, 26 Feb 2022 03:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50752C340F1;
        Sat, 26 Feb 2022 03:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645845081;
        bh=TpqGmpDe388CnUnPRivcHgWWsh5Jjhc4XanNCmHWYso=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=jg/7R5ZdNnfP52BcrIsBfcUm0xNAj+AW06YF4qV/x/m69qmEfwJHuagJJ6sXMi901
         pS5k0etZfGqz1ug7iBO6ttYIgnA3dWsOlHBNEo7T3aMFExHkynRPf+lCqyDkqhWBHH
         zhhgKm8LcOEcpVPdiepE/VmH9ljXxX10ZT5DDRJI=
Date:   Fri, 25 Feb 2022 19:11:20 -0800
To:     roman.gushchin@linux.dev, rientjes@google.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, cl@linux.com, vbabka@suse.cz,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
Subject: [patch 10/12] MAINTAINERS, SLAB: add Roman as reviewer, git tree
Message-Id: <20220226031121.50752C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
