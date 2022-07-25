Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F217C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 22:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbiGYWlq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237394AbiGYWlY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 18:41:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD72275C8
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 15:38:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DDFDB81132
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 22:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4B2C341D7;
        Mon, 25 Jul 2022 22:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658788680;
        bh=usQn66sXBBoUvp6w7E2OJ089SsTWAq6M4lWj7JaFV+Y=;
        h=Date:To:From:Subject:From;
        b=Fcng8h1Eat8I/ZVbF3mWgtBcCmCZewC6Ib6kqjgy2knQAqCaMYjQg/fDKRQH5T/iX
         qw08mK1ly9OwPSV7jUI1UvPIyAyCZKBat29ZiROczwlYbe60WGvkPqT7GdHqoW7EKA
         v/ddx5R0ip/9GdqUxlbz1j1XImftZNKyEjJFryHw=
Date:   Mon, 25 Jul 2022 15:37:59 -0700
To:     mm-commits@vger.kernel.org, tkhai@ya.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-kirills-email.patch added to mm-nonmm-unstable branch
Message-Id: <20220725223800.3E4B2C341D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Kirill's email
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-kirills-email.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-kirills-email.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kirill Tkhai <tkhai@ya.ru>
Subject: mailmap: update Kirill's email
Date: Mon, 25 Jul 2022 23:37:15 +0300

I disconnected from both Virtuozzo and OpenVZ, so this updates my email to
point to my own.  I haven't used @openvz address for patches, so let's
rewrite the line instead of to add a new one.  CC all previous addresses.

Link: https://lkml.kernel.org/r/14ca895b-e745-6ba2-8be8-652feacbc907@ya.ru
Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-kirills-email
+++ a/.mailmap
@@ -223,7 +223,7 @@ Kees Cook <keescook@chromium.org> <kees@
 Keith Busch <kbusch@kernel.org> <keith.busch@intel.com>
 Keith Busch <kbusch@kernel.org> <keith.busch@linux.intel.com>
 Kenneth W Chen <kenneth.w.chen@intel.com>
-Kirill Tkhai <kirill.tkhai@openvz.org> <ktkhai@virtuozzo.com>
+Kirill Tkhai <tkhai@ya.ru> <ktkhai@virtuozzo.com>
 Konstantin Khlebnikov <koct9i@gmail.com> <khlebnikov@yandex-team.ru>
 Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
 Koushik <raghavendra.koushik@neterion.com>
_

Patches currently in -mm which might be from tkhai@ya.ru are

mailmap-update-kirills-email.patch

