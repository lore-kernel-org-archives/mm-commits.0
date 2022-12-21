Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66A6C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiLUVsO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiLUVsO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:48:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A5D248E1
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:48:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B68AB8122F
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C38C433D2;
        Wed, 21 Dec 2022 21:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671659290;
        bh=hFmdQ4s8VfAnXM2tgjdYtdVK2Wv9I+CtnJaRcOI0jlU=;
        h=Date:To:From:Subject:From;
        b=grnBBaXNhITYOsTh17htFxopL3zIwU4Hak2XHdWesocEL/JWNYivtpefzx1c4/Pv1
         IO7tENdVTkSwrp/UmhWGtZBAmXQyEmu3264ysxt8YElkTwBxGLs6rJypZUFfUGXxkE
         88thClNOay45TRaOaFNkIGzc817VHuwedhjD77mo=
Date:   Wed, 21 Dec 2022 13:48:09 -0800
To:     mm-commits@vger.kernel.org, joel@joelfernandes.org,
        ribalda@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-add-permitted.patch added to mm-nonmm-unstable branch
Message-Id: <20221221214810.03C38C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add `permitted'
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-spellingtxt-add-permitted.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-spellingtxt-add-permitted.patch

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
From: Ricardo Ribalda <ribalda@chromium.org>
Subject: scripts/spelling.txt: add `permitted'
Date: Tue, 20 Dec 2022 23:20:30 +0100

Patch series "spelling: Fix some trivial typos".

Seems like permitted has two t's :), Lets add that to spellings to help
others.


This patch (of 3):

Add another common typo. Noticed when I sent a patch with the typo and
in kvm and of.

Link: https://lkml.kernel.org/r/20221220-permited-v1-1-52ea9857fa61@chromium.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-permitted
+++ a/scripts/spelling.txt
@@ -1121,6 +1121,7 @@ perfomring||performing
 periperal||peripheral
 peripherial||peripheral
 permissons||permissions
+permited||permitted
 peroid||period
 persistance||persistence
 persistant||persistent
_

Patches currently in -mm which might be from ribalda@chromium.org are

scripts-spellingtxt-add-permitted.patch
kvm-x86-fix-trivial-typo.patch
of-overlay-fix-trivial-typo.patch

