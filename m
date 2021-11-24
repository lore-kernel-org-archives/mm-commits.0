Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD467C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhKXAia (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:38:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229926AbhKXAia (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:38:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF8FB60F6B;
        Wed, 24 Nov 2021 00:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637714121;
        bh=jBpytqHH4EA9OsMJasK/58KLM6e7wTPyOBTt18Wxarw=;
        h=Date:From:To:Subject:From;
        b=kL1jsDKAD3QntWkgPWXz+4BagvdiXZwZ4mhjUTlh/s6NSW3Lm2spv4hAQI1Ku9W9C
         ACqw2DzBhPKa7Cyjn9kfVfKFQ0kAdU+3mKegkdiXfBuyH4F102DSKLkqjG0DDFFKXf
         /D9T7F4IGkLG7yJpxs0s5IVJ8HzEprplk5FtTefU=
Date:   Tue, 23 Nov 2021 16:35:21 -0800
From:   akpm@linux-foundation.org
To:     guoren@linux.alibaba.com, mm-commits@vger.kernel.org
Subject:  + mailmap-update-email-address-for-guo-ren.patch added to
 -mm tree
Message-ID: <20211124003521.5HH0Rrdyl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: Update email address for Guo Ren
has been added to the -mm tree.  Its filename is
     mailmap-update-email-address-for-guo-ren.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-update-email-address-for-guo-ren.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-update-email-address-for-guo-ren.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guo Ren <guoren@linux.alibaba.com>
Subject: mailmap: Update email address for Guo Ren

The ren_guo@c-sky.com would be deprecated and use guoren@kernel.org as the
main email address.

Link: https://lkml.kernel.org/r/20211123022741.545541-1-guoren@kernel.org
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-email-address-for-guo-ren
+++ a/.mailmap
@@ -126,6 +126,8 @@ Greg Kroah-Hartman <gregkh@suse.de>
 Greg Kroah-Hartman <greg@kroah.com>
 Greg Kurz <groug@kaod.org> <gkurz@linux.vnet.ibm.com>
 Gregory CLEMENT <gregory.clement@bootlin.com> <gregory.clement@free-electrons.com>
+Guo Ren <guoren@kernel.org> <guoren@linux.alibaba.com>
+Guo Ren <guoren@kernel.org> <ren_guo@c-sky.com>
 Gustavo Padovan <gustavo@las.ic.unicamp.br>
 Gustavo Padovan <padovan@profusion.mobi>
 Hanjun Guo <guohanjun@huawei.com> <hanjun.guo@linaro.org>
_

Patches currently in -mm which might be from guoren@linux.alibaba.com are

mailmap-update-email-address-for-guo-ren.patch

