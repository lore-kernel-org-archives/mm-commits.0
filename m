Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CF1C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59ADE610CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhICVCa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:32824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350431AbhICVC1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68587610E9;
        Fri,  3 Sep 2021 21:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702886;
        bh=UJuvws0hkZ1O9ZlArUbslHEWPUo3seS0iU8+xiYEypg=;
        h=Date:From:To:Subject:From;
        b=hYYbXzBQhsog1mv8FwN6z61oEUj/PjmS52zW4w3gFbF5gHIP7d2Nv7KQTc19MtnJ5
         CkCg9t0/qwvfi7HwyWZyV9AybavxUjruFdbwP4dHT37jLcpmvwNMefj+rt8Ucs3/VB
         IuUlbZudU9LH4PlKUjoEkJcA9QZ+a3zwDmA7sw5c=
Date:   Fri, 03 Sep 2021 14:01:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] mm-migrate-correct-kernel-doc-notation.patch
 removed from -mm tree
Message-ID: <20210903210126.Wg8UwYmbu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: correct kernel-doc notation
has been removed from the -mm tree.  Its filename was
     mm-migrate-correct-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/migrate: correct kernel-doc notation

Use the expected "Return:" format to prevent a kernel-doc warning.

mm/migrate.c:1157: warning: Excess function parameter 'returns' description in 'next_demotion_node'

Link: https://lkml.kernel.org/r/20210808203151.10632-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-correct-kernel-doc-notation
+++ a/mm/migrate.c
@@ -1149,7 +1149,7 @@ static int node_demotion[MAX_NUMNODES] _
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
  *
- * @returns: node id for next memory node in the demotion path hierarchy
+ * Return: node id for next memory node in the demotion path hierarchy
  * from @node; NUMA_NO_NODE if @node is terminal.  This does not keep
  * @node online or guarantee that it *continues* to be the next demotion
  * target.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

alpha-agp-make-empty-macros-use-do-while-0-style.patch
alpha-pci-sysfs-fix-all-kernel-doc-warnings.patch
lib-dump_stack-correct-kernel-doc-notation.patch
lib-iov_iterc-fix-kernel-doc-warnings.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch
mm-workingset-correct-kernel-doc-notations.patch
scripts-check_extable-fix-typo-in-user-error-message.patch

