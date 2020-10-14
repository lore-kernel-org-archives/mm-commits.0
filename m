Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC781C43467
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A6482224E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709315;
	bh=l5PZuVpX0G0Ouju4kY+ywUpSpSYVt2zSBkRRTOTgAhY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=kPj/ZkYktJUidwacAIdIpJ/GKgQKkNJTEdfGR1M9e07+naaBQLYvrQUyru0m5T/Ky
	 hbbSEh2k8rBHuWAAVvz6gDrinXVSiLkBok+0Xkb2GaZOT836oAVGH5VtlxoBEANXK8
	 L9icE9zYkOBF/1Azfpn5QWJWeha7RzCa9bFvRJ9o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbgJNVBm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730477AbgJNVBm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:42 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CC9F221FF;
        Wed, 14 Oct 2020 21:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709277;
        bh=l5PZuVpX0G0Ouju4kY+ywUpSpSYVt2zSBkRRTOTgAhY=;
        h=Date:From:To:Subject:From;
        b=siB34FjlohWjaiutfBJcWCEqmll+Mc6zoN1vyMLAf84NOvpQUf1JHTgKB+1QibkzK
         WeXiDjrji0tedhjzg9yDTJtVOjZaYE5god0kRV+07O0eOHEblPt1uCawqRFulwUtqY
         0LPtuLuVkk40vC82C2g1goadse+YCg1n5vSvkLGw=
Date:   Wed, 14 Oct 2020 14:01:17 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] mm-memoryc-fix-spello-of-function.patch removed
 from -mm tree
Message-ID: <20201014210117.FXP0sRXUG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix spello of "function"
has been removed from the -mm tree.  Its filename was
     mm-memoryc-fix-spello-of-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/memory.c: fix spello of "function"

Fix typo/spello of "function".

Link: https://lkml.kernel.org/r/e7bf180e-c558-b1d5-9a15-6d9708823c9c@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-fix-spello-of-function
+++ a/mm/memory.c
@@ -3764,7 +3764,7 @@ static vm_fault_t do_set_pmd(struct vm_f
 
 /**
  * alloc_set_pte - setup new PTE entry for given page and add reverse page
- * mapping. If needed, the fucntion allocates page table or use pre-allocated.
+ * mapping. If needed, the function allocates page table or use pre-allocated.
  *
  * @vmf: fault environment
  * @page: page to map
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-configfs-delete-repeated-words-in-comments.patch
kernel-fix-repeated-words-in-comments.patch
kernel-acctc-fix-some-kernel-doc-nits.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch
lib-mpi-fix-spello-of-functions.patch

