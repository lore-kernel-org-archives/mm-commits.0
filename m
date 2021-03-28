Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E68C433E5
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 666CC619AB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhC1TMQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231552AbhC1TLs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6F2561958;
        Sun, 28 Mar 2021 19:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958708;
        bh=z4cm/dnNRC9MbukP0yf6u11DqBAQByKe/61s1uT4iZU=;
        h=Date:From:To:Subject:From;
        b=vxJ/6U58yqPZSkmVDgIIxdvzfJbHXQBZLphb99JD71a+aB0Cjq74TtLusn3hsnhMj
         AIw/b6yZA7GznMNrJx6RVwXHPrEL9IB4WBfF0r37fekAo07omBrQymgPuZOvMTWyUv
         1qKFeApZ9ckyU7CzW/l0+oVLkr6C6BHWFoE5fAB8=
Date:   Sun, 28 Mar 2021 12:11:47 -0700
From:   akpm@linux-foundation.org
To:     alobakin@pm.me, corbet@lwn.net, jordan@cosmicpenguin.net,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        ojeda@kernel.org, tsbogend@alpha.franken.de
Subject:  + mailmap-update-email-address-for-jordan-crouse.patch
 added to -mm tree
Message-ID: <20210328191147.2FOmqSVxq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update email address for Jordan Crouse
has been added to the -mm tree.  Its filename is
     mailmap-update-email-address-for-jordan-crouse.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-update-email-address-for-jordan-crouse.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-update-email-address-for-jordan-crouse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jordan Crouse <jordan@cosmicpenguin.net>
Subject: mailmap: update email address for Jordan Crouse

jcrouse at codeaurora.org has started bouncing.  Redirect to a more
permanent address.

Link: https://lkml.kernel.org/r/20210325143700.1490518-1-jordan@cosmicpenguin.net
Signed-off-by: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-jordan-crouse
+++ a/.mailmap
@@ -168,6 +168,7 @@ Johan Hovold <johan@kernel.org> <jhovold
 Johan Hovold <johan@kernel.org> <johan@hovoldconsulting.com>
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
 John Stultz <johnstul@us.ibm.com>
+Jordan Crouse <jordan@cosmicpenguin.net> <jcrouse@codeaurora.org>
 <josh@joshtriplett.org> <josh@freedesktop.org>
 <josh@joshtriplett.org> <josh@kernel.org>
 <josh@joshtriplett.org> <josht@linux.vnet.ibm.com>
_

Patches currently in -mm which might be from jordan@cosmicpenguin.net are

mailmap-update-email-address-for-jordan-crouse.patch

