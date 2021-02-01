Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482ECC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07FA064ECB
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhBAXf2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:35:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231136AbhBAXf1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:35:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8FE964EC6;
        Mon,  1 Feb 2021 23:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612222486;
        bh=OaRmxzfO69/HDHZrjYMdO0H2hpnitAINnxugmvlLFHE=;
        h=Date:From:To:Subject:From;
        b=SaviLzHxieirt7OLM1cptTDECUixwKSin3s/rc5ocW6rRe/mwfulk45h0ZoDmoCEd
         I82nm7AkjH0xLtKh1hQxRY44I0oDeD5HIjg0AED3sF9AS4gplGm24JrEgEIinZR8QI
         yKQGURDyVI3mWcleuIgF6JRRbEx1+gehtPSwgPIY=
Date:   Mon, 01 Feb 2021 15:34:46 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viresh.kumar@linaro.org
Subject:  + mailmap-fix-name-email-for-viresh-kumar.patch added to
 -mm tree
Message-ID: <20210201233446.zXFW7_0Cm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: fix name/email for Viresh Kumar
has been added to the -mm tree.  Its filename is
     mailmap-fix-name-email-for-viresh-kumar.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-fix-name-email-for-viresh-kumar.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-fix-name-email-for-viresh-kumar.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mailmap-fix-name-email-for-viresh-kumar.patch

