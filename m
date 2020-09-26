Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42612C4727C
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07BE42087D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601085472;
	bh=/6xv6ZWXaLybVwg/W0+IPZSBOiRPOfHcjJ/L3MESmXk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IcaobnhLTpuHqNUi3xr2J+HSD4tMyDV0kYZ9ATYOUvRFNCOko/domnes8GSpVJABa
	 9J4DOcFO6OCSHCPyQaIHfMPV0g7VixjXb9RT06CCgNRLHVVPq8UJS437zX5XEySmEr
	 ZVbX3Jo+bTA/SPeNWwsL4yqR3+iCx8Sv+sf692V0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgIZB5v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 21:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIZB5v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 21:57:51 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C847E207EA;
        Sat, 26 Sep 2020 01:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085471;
        bh=/6xv6ZWXaLybVwg/W0+IPZSBOiRPOfHcjJ/L3MESmXk=;
        h=Date:From:To:Subject:From;
        b=EvAgVr1P06E/3gk+TtAil7O3lFWS6G4PepghzOeR2fDBtV98HGV9zoNhtWGFoPx9P
         WJ/wkl3cJOzXw4j+cjlJG03ag9qagXNA6FUJnlYAJgYrh8z16vkDGqC2BwOIZ42ucr
         aIYZPBiOQQyTfeVy5eMGhfUKYEej8jAriQq08U0Q=
Date:   Fri, 25 Sep 2020 18:57:50 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, joe@perches.com, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mailmap-add-older-email-addresses-for-kees-cook.patch removed from -mm tree
Message-ID: <20200926015750.WC7U5AnNl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add older email addresses for Kees Cook
has been removed from the -mm tree.  Its filename was
     mailmap-add-older-email-addresses-for-kees-cook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


