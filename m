Return-Path: <SRS0=v6Vt=IE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4387C433DB
	for <mm-commits@archiver.kernel.org>; Sat,  6 Mar 2021 00:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CEA3601FE
	for <mm-commits@archiver.kernel.org>; Sat,  6 Mar 2021 00:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCFAA2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Mar 2021 19:00:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhCEX77 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Mar 2021 18:59:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 997D3650AA;
        Fri,  5 Mar 2021 23:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614988794;
        bh=8SE4ZxCfvgfJBWjmGl1PcrL7L/x7eFe6f0SJHlionf4=;
        h=Date:From:To:Subject:From;
        b=k716Sc02B2WLywxE5uheEU1pn3zSMJxE/pYOcPsRU0VfOcKR6bHn1NIwJew6IGbQL
         Vea9tQAG5OmdLhQrXZpN5oHudzj7SkV063qIa5JQ2qR9eEwFXWmV04/fYn9gwJJIKT
         qgUMEnDCbYBj8sU3/FOBEuz7YVs0OwJYU0cUyeGw=
Date:   Fri, 05 Mar 2021 15:59:54 -0800
From:   akpm@linux-foundation.org
To:     drew@beagleboard.org, gustavoars@kernel.org,
        mm-commits@vger.kernel.org
Subject:  + scripts-spellingtxt-add-overflw.patch added to -mm tree
Message-ID: <20210305235954.X7cBTOnta%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "overflw"
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-overflw.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-overflw.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-overflw.patch

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
Subject: scripts/spelling.txt: add "overflw"

Add typo "overflw" for "overflow".  This typo was found and fixed in
drivers/clocksource/timer-pistachio.c.

Link: https://lore.kernel.org/lkml/20210305090315.384547-1-drew@beagleboard.org/
Link: https://lkml.kernel.org/r/20210305095151.388182-1-drew@beagleboard.org
Signed-off-by: Drew Fustini <drew@beagleboard.org>
Suggested-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-overflw
+++ a/scripts/spelling.txt
@@ -1014,6 +1014,7 @@ oustanding||outstanding
 overaall||overall
 overhread||overhead
 overlaping||overlapping
+overflw||overflow
 overlfow||overflow
 overide||override
 overrided||overridden
_

Patches currently in -mm which might be from drew@beagleboard.org are

scripts-spellingtxt-add-overlfow.patch
scripts-spellingtxt-add-overflw.patch

