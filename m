Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DDB6C2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0420620870
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604454672;
	bh=UpmQd2129b/PtpXSSoJqqJnY+OTLwX/9vov/YAX8hls=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=n6Kn2qH+c7WDJklGpaEjk7Mz7feCgMoNKbvqVGU3pftavZsTmi6+BQHgm5azvZRpM
	 lO4epT43TB1qHjTsfyCPAMr1Ndj5M5FsL8aUi0mUwQ2Go2crypTfkXOB1WOidgShmb
	 RkeLQEEj0IwfzRlopl31fw8VZ5DnweNkEQuKRbd0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgKDBvL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 20:51:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgKDBvL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 20:51:11 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1880020870;
        Wed,  4 Nov 2020 01:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604454670;
        bh=UpmQd2129b/PtpXSSoJqqJnY+OTLwX/9vov/YAX8hls=;
        h=Date:From:To:Subject:From;
        b=yQ51RG9SaTSrxw2L/Snq0gW+Wmbi4EgL/7yfZB6oRLX7UyXbCVEwOWqLgovWXgRoh
         HuKgy0Xp7r5UKNwOp/kCR0K/dAP8E+nBtUKNrqTd3E4+X8AYg1MEld+UuCXO9ovjUS
         t7Fpcd04eeNNZURmW+LutiVZTrXYQFAhwMag8NFw=
Date:   Tue, 03 Nov 2020 17:51:09 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, dbaryshkov@gmail.com
Subject:  +
 mailmap-fix-entry-for-dmitry-baryshkov-eremin-solenikov.patch added to -mm
 tree
Message-ID: <20201104015109.IIvaN%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: fix entry for Dmitry Baryshkov/Eremin-Solenikov
has been added to the -mm tree.  Its filename is
     mailmap-fix-entry-for-dmitry-baryshkov-eremin-solenikov.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-fix-entry-for-dmitry-baryshkov-eremin-solenikov.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-fix-entry-for-dmitry-baryshkov-eremin-solenikov.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: mailmap: fix entry for Dmitry Baryshkov/Eremin-Solenikov

Change back surname to new (old) one.  Dmitry Baryshkov -> Dmitry
Eremin-Solenikov -> Dmitry Baryshkov.  Map several odd entries to main
identity.

Link: https://lkml.kernel.org/r/20201103005158.1181426-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-fix-entry-for-dmitry-baryshkov-eremin-solenikov
+++ a/.mailmap
@@ -82,7 +82,10 @@ Dengcheng Zhu <dzhu@wavecomp.com> <dengc
 Dengcheng Zhu <dzhu@wavecomp.com> <dengcheng.zhu@imgtec.com>
 Dengcheng Zhu <dzhu@wavecomp.com> <dengcheng.zhu@mips.com>
 <dev.kurt@vandijck-laurijssen.be> <kurt.van.dijck@eia.be>
-Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
+Dmitry Baryshkov <dbaryshkov@gmail.com>
+Dmitry Baryshkov <dbaryshkov@gmail.com> <[dbaryshkov@gmail.com]>
+Dmitry Baryshkov <dbaryshkov@gmail.com> <dmitry_baryshkov@mentor.com>
+Dmitry Baryshkov <dbaryshkov@gmail.com> <dmitry_eremin@mentor.com>
 Dmitry Safonov <0x7f454c46@gmail.com> <dima@arista.com>
 Dmitry Safonov <0x7f454c46@gmail.com> <d.safonov@partner.samsung.com>
 Dmitry Safonov <0x7f454c46@gmail.com> <dsafonov@virtuozzo.com>
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

mailmap-fix-entry-for-dmitry-baryshkov-eremin-solenikov.patch

