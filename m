Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E7DC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 17:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCF7664DF0
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 17:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbhBHRZW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Feb 2021 12:25:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:35844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234889AbhBHRXT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Feb 2021 12:23:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B28A64EC2;
        Mon,  8 Feb 2021 17:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612804859;
        bh=9p1v82a3QWak1WKVZQou1NRoHOCaudsJ/f3yQgH21/k=;
        h=Date:From:To:Subject:From;
        b=fyEzyeojbpIKUit6JMIABKHphaX8anE9CgEbn2ufAT+2dWWjnKBUYOgX7n/HM1oN8
         LNhxJSXCbaI8rq/OcczYeeSOn682AbvFUxJe2CMFmHRZXU97OEiigbQlOR1HqVhNMS
         96BHNsvmZS2Q1gdoofn8cO5TwXX8R/R/5Gol25Kc=
Date:   Mon, 08 Feb 2021 09:20:59 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viresh.kumar@linaro.org
Subject:  [merged] mailmap-fix-name-email-for-viresh-kumar.patch
 removed from -mm tree
Message-ID: <20210208172059.35TdZ_Nd0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: fix name/email for Viresh Kumar
has been removed from the -mm tree.  Its filename was
     mailmap-fix-name-email-for-viresh-kumar.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: mailmap: fix name/email for Viresh Kumar

For some of the patches the email id was misspelled to linaro.com instead
of linaro.org and for others Viresh Kumar was written as "viresh kumar"
(all small).  Fix both with help of mailmap entries.

Link: https://lkml.kernel.org/r/d6b80b210d7fe0ddc1d4d0b22eff9708c72ef8b3.1612178938.git.viresh.kumar@linaro.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-fix-name-email-for-viresh-kumar
+++ a/.mailmap
@@ -334,6 +334,8 @@ Vinod Koul <vkoul@kernel.org> <vkoul@inf
 Viresh Kumar <vireshk@kernel.org> <viresh.kumar2@arm.com>
 Viresh Kumar <vireshk@kernel.org> <viresh.kumar@st.com>
 Viresh Kumar <vireshk@kernel.org> <viresh.linux@gmail.com>
+Viresh Kumar <viresh.kumar@linaro.org> <viresh.kumar@linaro.org>
+Viresh Kumar <viresh.kumar@linaro.org> <viresh.kumar@linaro.com>
 Vivien Didelot <vivien.didelot@gmail.com> <vivien.didelot@savoirfairelinux.com>
 Vlad Dogaru <ddvlad@gmail.com> <vlad.dogaru@intel.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@parallels.com>
_

Patches currently in -mm which might be from viresh.kumar@linaro.org are


