Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C41BC43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC9A8221EC
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600489201;
	bh=SIrcYMq4VM7fQey5vsNoaBB48H2LOx7flo+y13EJ274=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NCGOm8AdS1cxM/9UGTkT/M3DD9RjkiBgFGstr3SWYKljNvgrWP8OvtuoV0ie7Gmwd
	 TEhen+T2WLZhZ3S7WTbd1wrAaqMwSCrfeWls56s2gRBQWvaPVgjvDVjGfmol3SSITV
	 NdeC5pbPtP/s1AxTPR1Y/kRcV+kTDvmvL+5W1qWY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgISEUB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Sep 2020 00:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISEUB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Sep 2020 00:20:01 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE0F520874;
        Sat, 19 Sep 2020 04:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600489200;
        bh=SIrcYMq4VM7fQey5vsNoaBB48H2LOx7flo+y13EJ274=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=r5NRdPg3iO7uv4D8UoK6+s3mvigf1M79JodtHmMVsrCEKgIVp7oo3KLnumNl+Rji6
         zScfiKKJZ/Cc9lWdwB/3aCWyrA+ZDhY3TXdDvc5PzaakKC8PYr/gD+A4QZHgkxRsPX
         SKFUaSoAIqveFLYzot2NcclW3DMV8Ff8s33ddybY=
Date:   Fri, 18 Sep 2020 21:20:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, joe@perches.com,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 01/15] mailmap: add older email addresses for Kees
 Cook
Message-ID: <20200919042000.RBdTE6WLS%akpm@linux-foundation.org>
In-Reply-To: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: mailmap: add older email addresses for Kees Cook

This adds explicit mailmap entries for my older/other email addresses.

Link: https://lkml.kernel.org/r/20200910193939.3798377-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    4 ++++
 1 file changed, 4 insertions(+)

--- a/.mailmap~mailmap-add-older-email-addresses-for-kees-cook
+++ a/.mailmap
@@ -169,6 +169,10 @@ Juha Yrjola <juha.yrjola@solidboot.com>
 Julien Thierry <julien.thierry.kdev@gmail.com> <julien.thierry@arm.com>
 Kamil Konieczny <k.konieczny@samsung.com> <k.konieczny@partner.samsung.com>
 Kay Sievers <kay.sievers@vrfy.org>
+Kees Cook <keescook@chromium.org> <kees.cook@canonical.com>
+Kees Cook <keescook@chromium.org> <keescook@google.com>
+Kees Cook <keescook@chromium.org> <kees@outflux.net>
+Kees Cook <keescook@chromium.org> <kees@ubuntu.com>
 Kenneth W Chen <kenneth.w.chen@intel.com>
 Konstantin Khlebnikov <koct9i@gmail.com> <khlebnikov@yandex-team.ru>
 Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
_
