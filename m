Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D630C43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 553B120758
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599953914;
	bh=zvstKSRhzRz4/7Bc08839whZEz0TnVE7xhASt48wVxw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=eUw0AHtc4ps7+3eo+tWS2iGK3HRH1/UBWGpSfg1lPmOfc+nHbtVv9AvoWvcmx1bso
	 VOv/V9FtBaKUBX167nXGnO9kz2Dq2TkqM3d2WAkwU86DDVzlXtu6x+ZsXRzdYB/10Z
	 rSPIErHBA51qQZT9oHc9e8pTKy4iGeVikrTeEUgE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgILXic (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 19:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbgILXib (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 19:38:31 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0EC420758;
        Sat, 12 Sep 2020 23:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599953911;
        bh=zvstKSRhzRz4/7Bc08839whZEz0TnVE7xhASt48wVxw=;
        h=Date:From:To:Subject:From;
        b=CeZB7BN8BkG2LHYSOCu0fXRoVFqVndLWLO7KcRYWjKA8GdP+SGHzqkl0/MaQAaXLn
         qZTiphNDKb4sDroZ0vewdiajCu4Hq/uGAmFs/KHpkrnDZPe4r1sxzi6Px3DIrEcxp9
         5iN/pjVVluC6/VXm/RG6gTfL2bREyNuNFVUQ1Ba0=
Date:   Sat, 12 Sep 2020 16:38:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, joe@perches.com, corbet@lwn.net,
        keescook@chromium.org
Subject:  + mailmap-add-older-email-addresses-for-kees-cook.patch
 added to -mm tree
Message-ID: <20200912233830.-z3pM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add older email addresses for Kees Cook
has been added to the -mm tree.  Its filename is
     mailmap-add-older-email-addresses-for-kees-cook.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-add-older-email-addresses-for-kees-cook.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-add-older-email-addresses-for-kees-cook.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from keescook@chromium.org are

mailmap-add-older-email-addresses-for-kees-cook.patch

