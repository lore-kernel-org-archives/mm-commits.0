Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B4CC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 771AC65005
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCEByK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Mar 2021 20:54:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhCEByK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Mar 2021 20:54:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A02A864E68;
        Fri,  5 Mar 2021 01:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614909249;
        bh=gYBkbgG1Wl2x8A6IFmKYXoL0mS4MBk+uxXP/JAFTWG0=;
        h=Date:From:To:Subject:From;
        b=ndXKsJjVy3lFK5VD4g84SblJQXoD+p6NhPNbWhq5noBPkbtw/vaVP8gaXKHj5aIVW
         xOV8dNStjkry58MX7cjfNr5+iRFKeYdnnyfPEVHFsMeQASI6Vef8wlgY9xHzxXgUhB
         seGSXSwHBoHNoZmEJQtXTa8sJ+n3MQBBYMiUY5SA=
Date:   Thu, 04 Mar 2021 17:54:09 -0800
From:   akpm@linux-foundation.org
To:     drew@beagleboard.org, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  + scripts-spellingtxt-add-overlfow.patch added to -mm
 tree
Message-ID: <20210305015409.INEmMsqS0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "overlfow"
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-overlfow.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-overlfow.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-overlfow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Drew Fustini <drew@beagleboard.org>
Subject: scripts/spelling.txt: add "overlfow"

Add typo "overlfow" for "overflow". This typo was found and fixed in
net/sctp/tsnmap.c.

Link: https://lore.kernel.org/netdev/20210304055548.56829-1-drew@beagleboard.org/
Link: https://lkml.kernel.org/r/20210304072657.64577-1-drew@beagleboard.org
Signed-off-by: Drew Fustini <drew@beagleboard.org>
Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-overlfow
+++ a/scripts/spelling.txt
@@ -1013,6 +1013,7 @@ oustanding||outstanding
 overaall||overall
 overhread||overhead
 overlaping||overlapping
+overlfow||overflow
 overide||override
 overrided||overridden
 overriden||overridden
_

Patches currently in -mm which might be from drew@beagleboard.org are

scripts-spellingtxt-add-overlfow.patch

