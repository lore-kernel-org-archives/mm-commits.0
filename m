Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84ED4C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B507207BB
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597791795;
	bh=IukHK+tzawYpI+vctIuLFX93I7e7NGZdEcFTbtu2cDU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xsZOfRLBiTk/k+ijHrhv8g+m4nac+xGA6gavovHUa7P/pwKsMYC6sOvcQMW4eo7nY
	 dffGmmdVJDFF+XRm5FIQFL4HUMZaeXv0SD0vsz+wV1JJqRX6ztD2ri7LYsayLdGOYx
	 DT4u/1zn8yk9pB3Ekqfg062S5HrAPtyeVqexknTo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgHRXDP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726995AbgHRXDO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 19:03:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5C3120738;
        Tue, 18 Aug 2020 23:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597791793;
        bh=IukHK+tzawYpI+vctIuLFX93I7e7NGZdEcFTbtu2cDU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lDzxj833hjOE0OY1cuzhv5I82UAKUFObhNC1UfesyZaSC6dwqkP2xoXZRSYo7GDV2
         FZ/JhZHFmDjjusV2bQdjWDZoyZe0614DXE6RWz6Mv+5BVlAIbfeoLZf3zd8QXwx514
         vwZZOAZXBAa/A1kEWhRdC/XXChnP0u5Ao6/1Wlp4=
Date:   Tue, 18 Aug 2020 16:03:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ak@linux.intel.com, corbet@lwn.net, keescook@chromium.org,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        qperret@qperret.net
Subject:  + mailmap-add-andi-kleen.patch added to -mm tree
Message-ID: <20200818230313.HQjGniuzh%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add Andi Kleen
has been added to the -mm tree.  Its filename is
     mailmap-add-andi-kleen.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mailmap-add-andi-kleen.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mailmap-add-andi-kleen.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: mailmap: add Andi Kleen

I keep getting bounce back from the suse.de address.

Link: http://lkml.kernel.org/r/20200818203214.659955-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Quentin Perret <qperret@qperret.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-andi-kleen
+++ a/.mailmap
@@ -32,6 +32,7 @@ Alex Shi <alex.shi@linux.alibaba.com> <a
 Alex Shi <alex.shi@linux.alibaba.com> <alex.shi@linaro.org>
 Al Viro <viro@ftp.linux.org.uk>
 Al Viro <viro@zenIV.linux.org.uk>
+Andi Kleen <ak@linux.intel.com> <ak@suse.de>
 Andi Shyti <andi@etezian.org> <andi.shyti@samsung.com>
 Andreas Herrmann <aherrman@de.ibm.com>
 Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from ndesaulniers@google.com are

mailmap-add-andi-kleen.patch

