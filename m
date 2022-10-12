Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDB6C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 21:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJLVC3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 17:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiJLVCJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 17:02:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862894F6AB
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 14:01:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 49DD6CE1C97
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 21:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F79C433C1;
        Wed, 12 Oct 2022 21:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665608499;
        bh=Pwnz6dHksp14q34GZo5Hx1rlGrfBamUaEsoMAzveMFI=;
        h=Date:To:From:Subject:From;
        b=0rVTo5XsE9ngjM90R+GR3mcrhUt4J8gCQgVRMqYy64uzvjpKB05kGGonfNGC2aSUi
         2uLPAwvek7Ykpo3Q+PUHypg8VDQ3SiQajEZ+4NQvvdTmcocBqqtXZLau9Y8KeEFliC
         UifyXSVqfD7c4M9jFQwjOIGTn067mG9sfORE7jTk=
Date:   Wed, 12 Oct 2022 14:01:38 -0700
To:     mm-commits@vger.kernel.org, joe@perches.com,
        dan.carpenter@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-dan-carpenters-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20221012210139.86F79C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Dan Carpenter's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-dan-carpenters-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-dan-carpenters-email-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mailmap: update Dan Carpenter's email address
Date: Wed, 12 Oct 2022 16:19:39 +0300

My time at Oracle is ending at the end of the month.  Update my email
address accordingly.

Link: https://lkml.kernel.org/r/Y0a+6+5SHMdvUnpg@kili
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-dan-carpenters-email-address
+++ a/.mailmap
@@ -101,6 +101,7 @@ Christoph Hellwig <hch@lst.de>
 Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
 Corey Minyard <minyard@acm.org>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
+Dan Carpenter <error27@gmail.com> <dan.carpenter@oracle.com>
 Daniel Borkmann <daniel@iogearbox.net> <danborkmann@googlemail.com>
 Daniel Borkmann <daniel@iogearbox.net> <danborkmann@iogearbox.net>
 Daniel Borkmann <daniel@iogearbox.net> <daniel.borkmann@tik.ee.ethz.ch>
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mailmap-update-dan-carpenters-email-address.patch

