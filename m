Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1627C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97C6623A5E
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbhAUW0M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Jan 2021 17:26:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726431AbhAUW0H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Jan 2021 17:26:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1E3A221E5;
        Thu, 21 Jan 2021 22:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611267924;
        bh=gvEcNWxr1Sw1lSq7DG3hML1ltb/R0XGahQq2/HYMgwc=;
        h=Date:From:To:Subject:From;
        b=Pg0x4Cv0Mx9Mecm9skLI6CoddGnQqeloFOZmPx20xbbE22/P8k/xN4QINxWR1qboD
         3CrZcNtmBobJpMWGPbZs4z/z8lEEOk0nOlb2TEHO49sJ4LDDjDtjF5mqrkiw/8dcZs
         UIUICOr5YZU97KKqdzSS3U/CYDvSG9vJn2f9pSeQ=
Date:   Thu, 21 Jan 2021 14:25:23 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tangchunyou@yulong.com,
        zhangwen@yulong.com
Subject:  +
 scripts-spellingtxt-increase-error-prone-spell-checking.patch added to -mm
 tree
Message-ID: <20210121222523.4fjbJCAqE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: increase error-prone spell checking
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-increase-error-prone-spell-checking.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-increase-error-prone-spell-checking.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-increase-error-prone-spell-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: tangchunyou <tangchunyou@yulong.com>
Subject: scripts/spelling.txt: increase error-prone spell checking

Increase maping spelling error check.

Link: https://lkml.kernel.org/r/20210121092125.2663-1-tangchunyou@163.com
Signed-off-by: WenZhang <zhangwen@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-increase-error-prone-spell-checking
+++ a/scripts/spelling.txt
@@ -875,6 +875,7 @@ manger||manager
 manoeuvering||maneuvering
 manufaucturing||manufacturing
 mappping||mapping
+maping||mapping
 matchs||matches
 mathimatical||mathematical
 mathimatic||mathematic
_

Patches currently in -mm which might be from tangchunyou@yulong.com are

scripts-spellingtxt-increase-error-prone-spell-checking.patch

