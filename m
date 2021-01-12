Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08347C4332B
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2B5C23135
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389925AbhAMAms (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 19:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391986AbhALXu1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 18:50:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE70D23132;
        Tue, 12 Jan 2021 23:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610495368;
        bh=u6wwpMUYCNQ5KCpzwNq+++EmdOrZkPCTm/p56rtCb+4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dOCNoUzQToYWm1VqyV89M0Q4jM5RaulF9ArMQopEuYis+og7G50uCGPwUxzHX3oyV
         vOvtIoJbZyHvKFKatbBqOVuC2w7i3yZca2e1nXEZZsuazULMMBbWO8LMPm9lYlKVKy
         AGfyQoEjF+72CFyCk6FBX+9CO8SJlASOalETJX34=
Date:   Tue, 12 Jan 2021 15:49:27 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 08/10] MAINTAINERS: add Vlastimil as slab
 allocators maintainer
Message-ID: <20210112234927.qjKNk9pDa%akpm@linux-foundation.org>
In-Reply-To: <20210112154839.abeb6e57de79480059fd9b0e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
