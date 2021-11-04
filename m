Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327E9C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 01:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F32F60E9C
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 01:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhKDBop (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Nov 2021 21:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231206AbhKDBop (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Nov 2021 21:44:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B065560FC2;
        Thu,  4 Nov 2021 01:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635990127;
        bh=PLFrK2nVYpRB5h0bqn6qVfS7LpgqzyL80OIsJ6M9MHM=;
        h=Date:From:To:Subject:From;
        b=kellQbD8zvsGiLLjwDsEz5HDsQiT109qfh9G8yXGZ6hq2oVOXEFhjdK9VqjfoktAq
         nLrK7vNHGb3trX9/9NsoB8r5rQm5lVAFmRU3h8ngnv6B2RUlGMaS2QARGIs5XzXtFW
         DylcNjNKBtEhVxNZxvhdpU6jx9lVaai+R3rGcmqQ=
Date:   Wed, 03 Nov 2021 18:42:07 -0700
From:   akpm@linux-foundation.org
To:     colin.i.king@gmail.com, colin.i.king@googlemail.com,
        mm-commits@vger.kernel.org
Subject:  + mailmap-update-email-address-for-colin-king.patch added
 to -mm tree
Message-ID: <20211104014207.fXg1yJ7lb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update email address for Colin King
has been added to the -mm tree.  Its filename is
     mailmap-update-email-address-for-colin-king.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-update-email-address-for-colin-king.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-update-email-address-for-colin-king.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.i.king@googlemail.com>
Subject: mailmap: update email address for Colin King

Colin King has moved to Intel to update gmail and Canonical email
addresses.

Link: https://lkml.kernel.org/r/20211102231617.78569-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-email-address-for-colin-king
+++ a/.mailmap
@@ -73,6 +73,8 @@ Chris Chiu <chris.chiu@canonical.com> <c
 Chris Chiu <chris.chiu@canonical.com> <chiu@endlessos.org>
 Christophe Ricard <christophe.ricard@gmail.com>
 Christoph Hellwig <hch@lst.de>
+Colin Ian King <colin.king@intel.com> <colin.king@canonical.com>
+Colin Ian King <colin.king@intel.com> <colin.i.king@gmail.com>
 Corey Minyard <minyard@acm.org>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
 Daniel Borkmann <daniel@iogearbox.net> <danborkmann@googlemail.com>
_

Patches currently in -mm which might be from colin.i.king@googlemail.com are

mm-damon-fix-a-few-spelling-mistakes-in-comments-and-a-pr_debug-message.patch
mailmap-update-email-address-for-colin-king.patch

