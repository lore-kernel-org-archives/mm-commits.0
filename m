Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2C2C3DA7A
	for <mm-commits@archiver.kernel.org>; Thu,  5 Jan 2023 19:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbjAETtw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 14:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbjAETtr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 14:49:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AA314D29
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 11:49:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41B44B81BAA
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 19:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD70BC433D2;
        Thu,  5 Jan 2023 19:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672948184;
        bh=zK1piJt1CGIJpgLZQ63eQEaf1tXMAzPuYChUU8LXHXw=;
        h=Date:To:From:Subject:From;
        b=rCr5yB0fXU8KKpkf4DN03vA90uFCMcRjW4BqsGD529PUsOwpyGbNmrkSyy+yNbcrR
         Z9+IDgCmbHJ7tKHv0Z4K408ARudgXwoRFIBWDUy9AjxDzFMDfuKGEytQFxnmy5FIqD
         lO94Y+3nsYXayayulRxzyjQs4c8nWn1YMecm/Rc4=
Date:   Thu, 05 Jan 2023 11:49:43 -0800
To:     mm-commits@vger.kernel.org, robh@kernel.org,
        joel@joelfernandes.org, ribalda@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] of-overlay-fix-trivial-typo.patch removed from -mm tree
Message-Id: <20230105194943.DD70BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: of: overlay: fix trivial typo
has been removed from the -mm tree.  Its filename was
     of-overlay-fix-trivial-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ricardo Ribalda <ribalda@chromium.org>
Subject: of: overlay: fix trivial typo
Date: Tue, 20 Dec 2022 23:20:32 +0100

Permitted is spelled with two t.

Link: https://lkml.kernel.org/r/20221220-permited-v1-3-52ea9857fa61@chromium.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Rob Herring <robh@kernel.org>
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

