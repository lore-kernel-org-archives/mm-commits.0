Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E251C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237121AbjHKXFV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237127AbjHKXDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E3F3C0D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09CDE67B6B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D269C433C8;
        Fri, 11 Aug 2023 23:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794913;
        bh=EEtamNnYKuBJhq86jTPgwIW45fB92tTggcG35bbkp54=;
        h=Date:To:From:Subject:From;
        b=OedOceob5yBqx5nanAIYdQthNxCG7U73HQDHG0HNCP2EWN3edusbQas91r+1yz3S9
         rJiDBLMGxl0c2uKkAG7K8vR/nwoqXHhbIoKc6HGb1Uw2EEFyzn/cjcQfyWQDd1dcit
         eXC6VdhLwroomQZYf7p4QC39RIJrgWvc7WlTo1vk=
Date:   Fri, 11 Aug 2023 16:01:52 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-mtree_insert-fix-typo-in-kernel-doc-description-of-gfp-flags.patch removed from -mm tree
Message-Id: <20230811230153.5D269C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: mtree_insert: fix typo in kernel-doc description of GFP flags
has been removed from the -mm tree.  Its filename was
     maple_tree-mtree_insert-fix-typo-in-kernel-doc-description-of-gfp-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: maple_tree: mtree_insert: fix typo in kernel-doc description of GFP flags
Date: Sat, 15 Jul 2023 11:40:38 +0300

Replace FGP_FLAGS with GFP_FLAGS

Link: https://lkml.kernel.org/r/20230715084038.987955-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-mtree_insert-fix-typo-in-kernel-doc-description-of-gfp-flags
+++ a/lib/maple_tree.c
@@ -6314,7 +6314,7 @@ EXPORT_SYMBOL(mtree_insert_range);
  * @mt: The maple tree
  * @index : The index to store the value
  * @entry: The entry to store
- * @gfp: The FGP_FLAGS to use for allocations.
+ * @gfp: The GFP_FLAGS to use for allocations.
  *
  * Return: 0 on success, -EEXISTS if the range is occupied, -EINVAL on invalid
  * request, -ENOMEM if memory could not be allocated.
_

Patches currently in -mm which might be from rppt@kernel.org are


