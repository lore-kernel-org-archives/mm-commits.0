Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31478C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237068AbjHKXFP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237126AbjHKXDr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5360C3C06
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6C1867AB8
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5D6C433C7;
        Fri, 11 Aug 2023 23:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794912;
        bh=3b7uwH4D8hTADfs35sE++ynF+XRm+QjfsBUs0bcIaFI=;
        h=Date:To:From:Subject:From;
        b=pFU+pCExpDyvMXViRH8i7d1BbfNjxIbwLdgAGD6vzLgJsA+iMmEyX5T1rEW2QDAGg
         lSASBpWmSMmd4FEyU7RLHaxfj4+/m0Mr1nd/YQ7cMRoftoGgIPyN0inVnm5GVu+D/u
         0uciLh5zmBvAHSRK2yf2wIaiAOdTu1knTdJ4vUSY=
Date:   Fri, 11 Aug 2023 16:01:51 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-mtree_insert-fix-typo-in-kernel-doc-description.patch removed from -mm tree
Message-Id: <20230811230152.4B5D6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: mtree_insert*: fix typo in kernel-doc description
has been removed from the -mm tree.  Its filename was
     maple_tree-mtree_insert-fix-typo-in-kernel-doc-description.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: maple_tree: mtree_insert*: fix typo in kernel-doc description
Date: Sat, 15 Jul 2023 17:39:20 +0300

Replace "Insert and entry at a give index" with "Insert an entry at a
given index"

Link: https://lkml.kernel.org/r/20230715143920.994812-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-mtree_insert-fix-typo-in-kernel-doc-description
+++ a/lib/maple_tree.c
@@ -6274,7 +6274,7 @@ int mtree_store(struct maple_tree *mt, u
 EXPORT_SYMBOL(mtree_store);
 
 /**
- * mtree_insert_range() - Insert an entry at a give range if there is no value.
+ * mtree_insert_range() - Insert an entry at a given range if there is no value.
  * @mt: The maple tree
  * @first: The start of the range
  * @last: The end of the range
@@ -6310,7 +6310,7 @@ retry:
 EXPORT_SYMBOL(mtree_insert_range);
 
 /**
- * mtree_insert() - Insert an entry at a give index if there is no value.
+ * mtree_insert() - Insert an entry at a given index if there is no value.
  * @mt: The maple tree
  * @index : The index to store the value
  * @entry: The entry to store
_

Patches currently in -mm which might be from rppt@kernel.org are


