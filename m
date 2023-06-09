Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F028C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjFIXTx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjFIXTw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:19:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332572D74
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:19:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2F2165CAF
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2253BC433D2;
        Fri,  9 Jun 2023 23:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686352790;
        bh=Btk/4DDu8MenTAH+OMJ+mydiLHujwVK4dCurhkDXEuQ=;
        h=Date:To:From:Subject:From;
        b=EI+yALdjlyeK4hIHVh4RYVTn3pXI2/nSiOfngtA6pkg1grghcCIeZqKeRdlzR3XO5
         MvL2BpBzYUaB757ZlCqYnl6Ua6vddSM4iSUn9w/9NM/cNda79KO8Jqe3CBi5UeemHK
         4UaY9KAZcnkU7Lx1dZcUCqXM9q0x8KKzImeWsbjQ=
Date:   Fri, 09 Jun 2023 16:19:49 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        lstoakes@gmail.com, jhubbard@nvidia.com, jgg@nvidia.com,
        jack@suse.cz, david@redhat.com, axboe@kernel.dk,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix.patch removed from -mm tree
Message-Id: <20230609231950.2253BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix.patch

This patch was dropped because it was folded into selftests-mm-gup_longterm-new-functional-test-for-foll_longterm.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix
Date: Tue Jun  6 07:41:28 PM PDT 2023

update .gitignore for gup_longterm, per Peter

Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix
+++ a/tools/testing/selftests/mm/.gitignore
@@ -39,3 +39,4 @@ local_config.h
 local_config.mk
 ksm_functional_tests
 mdwe_test
+gup_longterm
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
selftests-mm-gup_longterm-new-functional-test-for-foll_longterm.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

