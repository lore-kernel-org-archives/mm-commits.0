Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8BBFC25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 22:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiHTWQF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 18:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiHTWQE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 18:16:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD242F38C
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 15:16:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23672B80A08
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 22:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B49C433C1;
        Sat, 20 Aug 2022 22:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661033760;
        bh=E+dq+AqdGVWax6+W8+VC00LZ3gF5G5HFldp6xSq53rY=;
        h=Date:To:From:Subject:From;
        b=fhX/rHYaLJq8p15x705dZRrh/t+nD5XLcwLvVOxb+1/btYEBfz50ygLK/u96NPu84
         6fs6uiaX64WLe/TB17WvX+mN+veIlPzxvD+SPBC1l7R1TmHAjqvChKB+6hGOXPR8dT
         9oDsETnGsY9j1HNKB/+82lqaAG5mdgZC45IZYl2A=
Date:   Sat, 20 Aug 2022 15:16:00 -0700
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-colin-king.patch added to mm-hotfixes-unstable branch
Message-Id: <20220820221600.B5B49C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update email address for Colin King
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-email-address-for-colin-king.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-colin-king.patch

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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: mailmap: update email address for Colin King
Date: Wed, 17 Aug 2022 22:27:53 +0100

Colin King is working on kernel janitorial fixes in his spare time and
using his Intel email is confusing.  Use his gmail account as the default
email address.

Link: https://lkml.kernel.org/r/20220817212753.101109-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/.mailmap~mailmap-update-email-address-for-colin-king
+++ a/.mailmap
@@ -98,8 +98,7 @@ Christian Brauner <brauner@kernel.org> <
 Christian Marangi <ansuelsmth@gmail.com>
 Christophe Ricard <christophe.ricard@gmail.com>
 Christoph Hellwig <hch@lst.de>
-Colin Ian King <colin.king@intel.com> <colin.king@canonical.com>
-Colin Ian King <colin.king@intel.com> <colin.i.king@gmail.com>
+Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
 Corey Minyard <minyard@acm.org>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
 Daniel Borkmann <daniel@iogearbox.net> <danborkmann@googlemail.com>
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

mailmap-update-email-address-for-colin-king.patch

