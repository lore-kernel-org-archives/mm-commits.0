Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FBCC433E9
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 00:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0687A23AAA
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 00:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbhAIAye (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jan 2021 19:54:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:32980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbhAIAyd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 Jan 2021 19:54:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C989C23A75;
        Sat,  9 Jan 2021 00:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610153633;
        bh=MTUb9DRujEIx1QUjFIUA6bYHxwQuqMMdVypKj8Id+iM=;
        h=Date:From:To:Subject:From;
        b=2G2LL7fb/wAZThlE6hQ+Rnyt7ZQzc91dzioQ7OrOx7E7bQyCwFQD2zOaV7cGNjI9b
         b6qZOuJSPamXZ6UoYtQPzXq8dTC/rJgiU91d1xRXZ7BwUbMLMONE4nB/rrgg6eIUnI
         Ln38tBcUP7PNli1/5VbnDpXRaJiwIlrvIq8tt2ZA=
Date:   Fri, 08 Jan 2021 16:53:52 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  +
 maintainers-add-myself-as-slab-allocators-maintainer.patch added to -mm
 tree
Message-ID: <20210109005352.MHc5FVVKk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Vlastimil as slab allocators maintainer
has been added to the -mm tree.  Its filename is
     maintainers-add-myself-as-slab-allocators-maintainer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-myself-as-slab-allocators-maintainer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-myself-as-slab-allocators-maintainer.patch

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
Subject: MAINTAINERS: add Vlastimil as slab allocators maintainer

I would like to help with slab allocators maintenance, from the
perspective of being responsible for SLAB and more recently also SLUB in
an enterprise distro kernel and supporting its users.  Recently I've been
focusing on improving SLUB's debugging features, and patch review in the
area, including the kmemcg accounting rewrite last year.

Link: https://lkml.kernel.org/r/20210108110353.19971-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-slab-allocators-maintainer
+++ a/MAINTAINERS
@@ -16321,6 +16321,7 @@ M:	Pekka Enberg <penberg@kernel.org>
 M:	David Rientjes <rientjes@google.com>
 M:	Joonsoo Kim <iamjoonsoo.kim@lge.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Vlastimil Babka <vbabka@suse.cz>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/sl?b*.h
_

Patches currently in -mm which might be from vbabka@suse.cz are

maintainers-add-myself-as-slab-allocators-maintainer.patch

