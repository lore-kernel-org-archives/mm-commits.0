Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D621EC10F1B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiLUVsS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiLUVsQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:48:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383462495E
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:48:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 712806195E
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90D7C433EF;
        Wed, 21 Dec 2022 21:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671659293;
        bh=DCxHaI5CzcXakPIrnEaqkfJzjdJswYKBlfPfW71VnTI=;
        h=Date:To:From:Subject:From;
        b=v9ieYPu5ptIYtDrbmOLhTjuYZWbldt4/itgDbkr/vjqLAHKUYQ/PE60TPmyygj3o/
         /o93vg/jZNeF6Nc50WHIwRCkLG87LHtfrNeLZeQM7dcIqti3VeNqSeYOmDtXF4Pam5
         A6i7c03/zu77YXXWUMXRChBw54+2njrA5LIWCvvY=
Date:   Wed, 21 Dec 2022 13:48:13 -0800
To:     mm-commits@vger.kernel.org, joel@joelfernandes.org,
        ribalda@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + of-overlay-fix-trivial-typo.patch added to mm-nonmm-unstable branch
Message-Id: <20221221214813.C90D7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: of: overlay: fix trivial typo
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     of-overlay-fix-trivial-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/of-overlay-fix-trivial-typo.patch

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
Subject: of: overlay: fix trivial typo
Date: Tue, 20 Dec 2022 23:20:32 +0100

Permitted is spelled with two t.

Link: https://lkml.kernel.org/r/20221220-permited-v1-3-52ea9857fa61@chromium.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/overlay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/overlay.c~of-overlay-fix-trivial-typo
+++ a/drivers/of/overlay.c
@@ -1121,7 +1121,7 @@ static int node_overlaps_later_cs(struct
  * The topmost check is done by exploiting this property. For each
  * affected device node in the log list we check if this overlay is
  * the one closest to the tail. If another overlay has affected this
- * device node and is closest to the tail, then removal is not permited.
+ * device node and is closest to the tail, then removal is not permitted.
  */
 static int overlay_removal_is_ok(struct overlay_changeset *remove_ovcs)
 {
_

Patches currently in -mm which might be from ribalda@chromium.org are

scripts-spellingtxt-add-permitted.patch
kvm-x86-fix-trivial-typo.patch
of-overlay-fix-trivial-typo.patch

