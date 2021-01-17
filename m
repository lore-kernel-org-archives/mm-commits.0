Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BBDC43381
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E664122C97
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbhAQCMI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jan 2021 21:12:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbhAQCMH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 16 Jan 2021 21:12:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D56A22D0B;
        Sun, 17 Jan 2021 02:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610849461;
        bh=vd87QPbQYdpPTRRN2V5LPFUkecUaNlfLxlEFPMd0nmY=;
        h=Date:From:To:Subject:From;
        b=Q+xbb3tP2ZgEcJHSuxvUIZa51bj8toNYMCrFO175Xr8vLAfCtnCrd+LLwTVQOz6/l
         kxqn53tzYWsNRojj0Y11EgJBre2ZmwUDyskNgsbVfYrSUWDK4/r3Ri9hwaMwnSJF8v
         HsyWZdfLRH31Fq5zklf5QDKUAlliMF58rLmWLaAc=
Date:   Sat, 16 Jan 2021 18:11:01 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  [merged]
 maintainers-add-myself-as-slab-allocators-maintainer.patch removed from -mm
 tree
Message-ID: <20210117021101.DxFvrVqdN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Vlastimil as slab allocators maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-slab-allocators-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: MAINTAINERS: add Vlastimil as slab allocators maintainer

I would like to help with slab allocators maintenance, from the
perspective of being responsible for SLAB and more recently also SLUB in
an enterprise distro kernel and supporting its users.  Recently I've been
focusing on improving SLUB's debugging features, and patch review in the
area, including the kmemcg accounting rewrite last year.

Link: https://lkml.kernel.org/r/20210108110353.19971-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-slab-allocators-maintainer
+++ a/MAINTAINERS
@@ -16319,6 +16319,7 @@ M:	Pekka Enberg <penberg@kernel.org>
 M:	David Rientjes <rientjes@google.com>
 M:	Joonsoo Kim <iamjoonsoo.kim@lge.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Vlastimil Babka <vbabka@suse.cz>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/sl?b*.h
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-stop-freeing-kmem_cache_node-structures-on-node-offline.patch
mm-slab-slub-stop-taking-memory-hotplug-lock.patch
mm-slab-slub-stop-taking-cpu-hotplug-lock.patch

