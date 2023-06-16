Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7489EB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 19:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbjFPTlo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 15:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjFPTlo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 15:41:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BD4119
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 12:41:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9C906112C
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 19:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EBCC433C9;
        Fri, 16 Jun 2023 19:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686944502;
        bh=c0S2PBGq9hnSUSBPH11N4PuS+68jdb6Prqzn9J37rFA=;
        h=Date:To:From:Subject:From;
        b=veuyhxwL13BSwcvE4pIHU2NtcNWndnQkDsRv8JI8fbPChnGH/5o/KVPEwLPDAW2eN
         Tu3K+j/zb4ZJ+zhn0pFNbgDfEP32f9MBemucbv3Yjy+HuXbkSPNK08oD0xUeR1qC1V
         QJpSdq5+0juFK1n+/lf2D2PzGI4/kJ/dtvbju+jg=
Date:   Fri, 16 Jun 2023 12:41:41 -0700
To:     mm-commits@vger.kernel.org, ben-linux@fluff.org,
        ben.dooks@sifive.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-ben-dooks.patch added to mm-hotfixes-unstable branch
Message-Id: <20230616194141.F3EBCC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entries for Ben Dooks
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entries-for-ben-dooks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-ben-dooks.patch

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
From: Ben Dooks <ben.dooks@sifive.com>
Subject: mailmap: add entries for Ben Dooks
Date: Thu, 15 Jun 2023 09:18:20 +0100

I am going to be losing my sifive.com address soon and I also realised my
old Simtec address (from >10 years ago) is also not been updates so update
.mailmap for both.

Link: https://lkml.kernel.org/r/20230615081820.79485-1-ben.dooks@codethink.co.uk
Signed-off-by: Ben Dooks <ben.dooks@sifive.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-ben-dooks
+++ a/.mailmap
@@ -70,6 +70,8 @@ Baolin Wang <baolin.wang@linux.alibaba.c
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang7@gmail.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@wdc.com>
+Ben Dooks <ben-linux@fluff.org> <ben.dooks@simtec.co.uk>
+Ben Dooks <ben-linux@fluff.org> <ben.dooks@sifive.com>
 Ben Gardner <bgardner@wabtec.com>
 Ben M Cahill <ben.m.cahill@intel.com>
 Ben Widawsky <bwidawsk@kernel.org> <ben@bwidawsk.net>
_

Patches currently in -mm which might be from ben.dooks@sifive.com are

mailmap-add-entries-for-ben-dooks.patch

