Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D9ABC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19BDF221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709425;
	bh=2zBuMHhJSgronr1wwyzP9P4JoDtsXCdaU3qcmJGvvlg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EPpRe9Es/OWv7EuRuS5C0HsFvuNWfS0nP1SZblStPZLtzNpWpAfXhwmHBm3XQKGEf
	 4PKprlRjykqLMThLNEQXmVFie5RWMEpHCUUPwQNvemzi/VM2eDQ82JyfuaQP6jDzam
	 MfR83U7w39Lvj/6Cqlp02v2BKROOXHca6woGEDVY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbgJNVDo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVDo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E7CD206B2;
        Wed, 14 Oct 2020 21:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709423;
        bh=2zBuMHhJSgronr1wwyzP9P4JoDtsXCdaU3qcmJGvvlg=;
        h=Date:From:To:Subject:From;
        b=jP0vrGw8BnDgqZsEaYGwb9t6QvYIJZbkdEticTbMHt9PtU2g4zSVAH6llxwmf5Alm
         /oNSslX2/NK0iQm+2VqqKdpNtgsocEoG+LkyIzkH0/dsYzADHefUj5sQh7pxiifv94
         0sUhAdCHEfXEgGj7OSjxKu0N7Z9CO3a77y3s8gFE=
Date:   Wed, 14 Oct 2020 14:03:43 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sh_def@163.com
Subject:  [merged]
 mm-vmscan-fix-comments-for-isolate_lru_page.patch removed from -mm tree
Message-ID: <20201014210343.n-RKj4SeW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: fix comments for isolate_lru_page()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-comments-for-isolate_lru_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/vmscan: fix comments for isolate_lru_page()

fix comments for isolate_lru_page():
s/fundamentnal/fundamental

Link: https://lkml.kernel.org/r/20200927173923.GA8058@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-fix-comments-for-isolate_lru_page
+++ a/mm/vmscan.c
@@ -1754,7 +1754,7 @@ static unsigned long isolate_lru_pages(u
  * Restrictions:
  *
  * (1) Must be called with an elevated refcount on the page. This is a
- *     fundamentnal difference from isolate_lru_pages (which is called
+ *     fundamental difference from isolate_lru_pages (which is called
  *     without a stable reference).
  * (2) the lru_lock must not be held.
  * (3) interrupts must be enabled.
_

Patches currently in -mm which might be from sh_def@163.com are


