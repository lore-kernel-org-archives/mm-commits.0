Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864A6C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 699F460FEE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhGFTOm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231770AbhGFTOm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74B396023F;
        Tue,  6 Jul 2021 19:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598723;
        bh=whGqRpjKHabKn+jgFsAmk45dLx9Sr3xkVrFnE52tCag=;
        h=Date:From:To:Subject:From;
        b=FlU3+F4jFoPOQy5Eqhu0WEgzJwhoQ85PNx230/FkVKRbHGNNBhuQzKYM3HY2X/2MO
         7pqgDjn2R63ctBnp3GNIMkP2wY0U6g5qcpP7p/k4KbEgFZBXkrrpQSFBP6NWnSLJxo
         xbe/bJt0hGRpcL6WEsBwnUowKQ38hfo3JO4a6tnc=
Date:   Tue, 06 Jul 2021 12:12:03 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, denghuilong@cdjrlc.com, guro@fb.com,
        hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com
Subject:  [merged]
 mm-memcontrol-remove-trailing-semicolon-in-macros.patch removed from -mm
 tree
Message-ID: <20210706191203.jc08mimUN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove trailing semicolon in macros
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-trailing-semicolon-in-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huilong Deng <denghuilong@cdjrlc.com>
Subject: mm: memcontrol: remove trailing semicolon in macros

Macros should not use a trailing semicolon.

Link: https://lkml.kernel.org/r/20210614091530.22117-1-denghuilong@cdjrlc.com
Signed-off-by: Huilong Deng <denghuilong@cdjrlc.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-remove-trailing-semicolon-in-macros
+++ a/include/linux/memcontrol.h
@@ -192,7 +192,7 @@ enum memcg_kmem_state {
 struct memcg_padding {
 	char x[0];
 } ____cacheline_internodealigned_in_smp;
-#define MEMCG_PADDING(name)      struct memcg_padding name;
+#define MEMCG_PADDING(name)      struct memcg_padding name
 #else
 #define MEMCG_PADDING(name)
 #endif
_

Patches currently in -mm which might be from denghuilong@cdjrlc.com are


