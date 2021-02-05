Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0F9C433E9
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F1B764FBD
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhBECeq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 21:34:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230281AbhBECdr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 21:33:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E757C64FBF;
        Fri,  5 Feb 2021 02:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492360;
        bh=yZTR14s1kAe6pHxA1l+Wdu/HiTnzRNjKR1Xp9tN/nSw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cfQh62tLkYUIu1i1/ZC7KxVWSK/FUvfYcXKa736ZY0CFphCteUv2SL7frs5+eIRAU
         2vDZdal1SjJxmBbLM7ZUyaxR6qct0vpGe7/owM0eiepB6fLIJ+YCbeV8p/UUdofQo3
         pnPQ6eTKkZ1SJLuvLlYErX++vxC7vNVMBpEGF+48=
Date:   Thu, 04 Feb 2021 18:32:39 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viresh.kumar@linaro.org
Subject:  [patch 11/18] mailmap: fix name/email for Viresh Kumar
Message-ID: <20210205023239.GU3J2vOfy%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
