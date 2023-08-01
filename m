Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A297BC04A94
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 17:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbjHAR5a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 13:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbjHAR5Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 13:57:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB16B1BF5
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 10:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D99A61600
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 17:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8DCC433CB;
        Tue,  1 Aug 2023 17:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690912642;
        bh=Mip8tADswHFvR/LgZ+/nC5L3mxbPlabcQxSOiaPWZcs=;
        h=Date:To:From:Subject:From;
        b=hn+e5Dy25q2sLIiy9Wjc/7+GHPuXYRAP/JN+C799JXgTvxup1cpfr3VletkH1WeXX
         vxxsr52Bq5vnSQbSTbVmMlUByB3ScYMLtvPvWg2W4YjKr8PWKMn51l8YAE6vnaKYDq
         7igo5Df9/LpmcgfISZCiIGFTxWg7Den+36GKqeDw=
Date:   Tue, 01 Aug 2023 10:57:22 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-maple-tree-mailing-list.patch added to mm-hotfixes-unstable branch
Message-Id: <20230801175722.8F8DCC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add maple tree mailing list
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-maple-tree-mailing-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-maple-tree-mailing-list.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: MAINTAINERS: add maple tree mailing list
Date: Mon, 31 Jul 2023 13:55:42 -0400

There is a mailing list for the maple tree development.  Add the list to
the maple tree entry of the MAINTAINERS file so patches will be sent to
interested parties.

Link: https://lkml.kernel.org/r/20230731175542.1653200-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-maple-tree-mailing-list
+++ a/MAINTAINERS
@@ -12480,6 +12480,7 @@ F:	net/mctp/
 
 MAPLE TREE
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+L:	maple-tree@lists.infradead.org
 L:	linux-mm@kvack.org
 S:	Supported
 F:	Documentation/core-api/maple_tree.rst
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maintainers-add-maple-tree-mailing-list.patch
mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
maple_tree-adjust-node-allocation-on-mas_rebalance.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
maple_tree-reduce-resets-during-store-setup.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch

