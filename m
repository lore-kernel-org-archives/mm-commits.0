Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9B3C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1308B208B3
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633244;
	bh=uWonrTodfPl0JVZmTrc+uaZco8LLcO4TqWnVP4gLyoE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=OSKhU1esR40mAOgHQvbCtnQ21jSvPknjC/by6W1GaCfv13m+ktm5ErQXJty2DTwr4
	 ckSqA3iBzUK6PzS8DDE46MhBfLjiu3geqv7XiqO/+7uSYmlgxeHtW7aRMo5gkLroDY
	 9khiccweSjQUIafLsmay9k4TczJFOvAxmzDZYTPQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbgJMXyD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbgJMXyD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99741206D5;
        Tue, 13 Oct 2020 23:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633241;
        bh=uWonrTodfPl0JVZmTrc+uaZco8LLcO4TqWnVP4gLyoE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aFG+KszbhOQPUFSzHQ4fIWHe/wRF1s76esheg1TYJnBtOqMnnf+qNxaw53GpF7Ghc
         I2VxiW9BKSaoFejb8Ttt1eNnKEhoFWYRjkyRZvIQt0/5MWtyIT07xvHqZQ9oZdsqxU
         w6UDXiSi7Rj163DO9SHpYrWcPyMr5FC/ctW0iE/E=
Date:   Tue, 13 Oct 2020 16:54:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 103/181] mm/memory.c: fix spello of "function"
Message-ID: <20201013235401.5KiLfIGAv%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
