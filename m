Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0F7C433E0
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8527964EC1
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhBAXhA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:37:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhBAXg5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:36:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A518F64DDD;
        Mon,  1 Feb 2021 23:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612222576;
        bh=+I+/M+nsqYICnwN+xI8NKsWbuMeQDocPE3Oaj5I34W0=;
        h=Date:From:To:Subject:From;
        b=uPd3zlbxqVk8M16dYsWJZBMCsqJrSq6YG8omtn2elt4eldITG14vYW5MMoyNu6Ga5
         aRN7Cus5WIpWAGZC5Anb/ykkQkfTkXe57v8v+TPEV0lwSHma1yHN3rMfaLxqAJsog1
         ToQ9y7pXHzLJjTAZQLK747xrYRtKFnZWDsqXQPoc=
Date:   Mon, 01 Feb 2021 15:36:16 -0800
From:   akpm@linux-foundation.org
To:     manivannan.sadhasivam@linaro.org, mm-commits@vger.kernel.org
Subject:  + mailmap-add-entries-for-manivannan-sadhasivam.patch
 added to -mm tree
Message-ID: <20210201233616.VeY7mzMHA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entries for Manivannan Sadhasivam
has been added to the -mm tree.  Its filename is
     mailmap-add-entries-for-manivannan-sadhasivam.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-add-entries-for-manivannan-sadhasivam.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-add-entries-for-manivannan-sadhasivam.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: mailmap: add entries for Manivannan Sadhasivam

Map my personal and work addresses to korg mail address.

Link: https://lkml.kernel.org/r/20210201104640.108556-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-manivannan-sadhasivam
+++ a/.mailmap
@@ -199,6 +199,8 @@ Li Yang <leoyang.li@nxp.com> <leoli@free
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
 Maciej W. Rozycki <macro@mips.com> <macro@imgtec.com>
+Manivannan Sadhasivam <mani@kernel.org> <manivannanece23@gmail.com>
+Manivannan Sadhasivam <mani@kernel.org> <manivannan.sadhasivam@linaro.org>
 Marcin Nowakowski <marcin.nowakowski@mips.com> <marcin.nowakowski@imgtec.com>
 Marc Zyngier <maz@kernel.org> <marc.zyngier@arm.com>
 Mark Brown <broonie@sirena.org.uk>
_

Patches currently in -mm which might be from manivannan.sadhasivam@linaro.org are

mailmap-add-entries-for-manivannan-sadhasivam.patch

