Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C237EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 18:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjGQS1a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjGQS1T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 14:27:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6261BFF
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 11:26:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A48DC611EB
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 18:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEB5C433C8;
        Mon, 17 Jul 2023 18:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689618362;
        bh=Czw8SZTGc37khn88MHKvzbMua7sm6Yg09jjvzkqaZu8=;
        h=Date:To:From:Subject:From;
        b=mCnRde6T+CT3FCd5HEwOnYhDy0rA+PBj9JUY0H9fn80FO68NU8tIgce5dIvmLKiyv
         Pu+IJq/Krj9jfsR/cEvdkSHwTfFNSUL+WKjuQ1m8xgRAz2JGWVOTgg9FrCKNvSHVco
         baJhkVgO5Fbxs05jlZVgzek6a/OpLQH3rWVK7GR4=
Date:   Mon, 17 Jul 2023 11:26:01 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-mtree_insert-fix-typo-in-kernel-doc-description-of-gfp-flags.patch added to mm-unstable branch
Message-Id: <20230717182601.EEEB5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: mtree_insert: fix typo in kernel-doc description of GFP flags
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-mtree_insert-fix-typo-in-kernel-doc-description-of-gfp-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-mtree_insert-fix-typo-in-kernel-doc-description-of-gfp-flags.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

maple_tree-mtree_insert-fix-typo-in-kernel-doc-description.patch
maple_tree-mtree_insert-fix-typo-in-kernel-doc-description-of-gfp-flags.patch

