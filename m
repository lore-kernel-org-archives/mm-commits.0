Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10472C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDC4820768
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266109;
	bh=KAUmSuwz1U84XUxwebA6EZKsK0ZGWt/qa7jfM8xw4DE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Q0SyiPBJmi0nVa+6FyjgnB08OmjyhZ3AzU+5Uvf3ZS2Gg5np5eKJcc1iNlg19nYLD
	 xk3lbjDEF8+HSJEONRxkJxJyeTaJTzGrZnzdQOcpNy/eaDTXRmJYSZC4ITP9lnNiMi
	 xLCp73kqqUt9DXgWJBFVVjNVLy6ifbnmpJIMBvBM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHLVBt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbgHLVBs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 764862078B;
        Wed, 12 Aug 2020 21:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266108;
        bh=KAUmSuwz1U84XUxwebA6EZKsK0ZGWt/qa7jfM8xw4DE=;
        h=Date:From:To:Subject:From;
        b=CoVYMME6UtepHU2++BjWLTNcuEL2ItAL5T1UFUczFAKZWh8VAMP+FpDiZDAL3RRic
         83yAYtUZ7QHGgQn2wOoBAwYo4og0Ksxf4LDZ1dMM/hYG7houy9wodnYy0gjzvJ+f2Z
         Svw3d43+lAKwmaBmXZviPYADGzqakgHHNkKrt0+c=
Date:   Wed, 12 Aug 2020 14:01:48 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        yanfei.xu@windriver.com
Subject:  [merged] mempolicyh-fix-typo.patch removed from -mm tree
Message-ID: <20200812210148.sNg9hoqkL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mempolicy.h: fix typo
has been removed from the -mm tree.  Its filename was
     mempolicyh-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: include/linux/mempolicy.h: fix typo

Change "interlave" to "interleave".

Link: http://lkml.kernel.org/r/20200810063454.9357-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mempolicy.h~mempolicyh-fix-typo
+++ a/include/linux/mempolicy.h
@@ -28,7 +28,7 @@ struct mm_struct;
  * the process policy is used. Interrupts ignore the memory policy
  * of the current process.
  *
- * Locking policy for interlave:
+ * Locking policy for interleave:
  * In process context there is no locking because only the process accesses
  * its own state. All vma manipulation is somewhat protected by a down_read on
  * mmap_lock.
_

Patches currently in -mm which might be from yanfei.xu@windriver.com are


