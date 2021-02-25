Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B83BC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D089864F75
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhBYTOZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:14:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233844AbhBYTLz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:11:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E88164EFA;
        Thu, 25 Feb 2021 19:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280274;
        bh=r2PVQ4Q56Am5caNYCUyM4nxoNf/+VX9d+/AeBMaP8Lk=;
        h=Date:From:To:Subject:From;
        b=kTHtg15XlWU7j5rvPeylJ0Tic1FsFDS/iK8qGYQ50ukbyUYhMg9oeiNoeTht02uw+
         Torlh21+1P/akwrUxKNahGR3LXNGpiIyuZDjY1y2sH2aN4FaTLlKeldJWq2K3GES8r
         mDjE+z+bSUA0jZcIzwW6GgGPN9ViaWNQ9xPzzQD4=
Date:   Thu, 25 Feb 2021 11:11:14 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tangchunyou@yulong.com,
        zhangwen@yulong.com
Subject:  [merged]
 scripts-spellingtxt-increase-error-prone-spell-checking.patch removed from
 -mm tree
Message-ID: <20210225191114.ZO6hZuBze%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: increase error-prone spell checking
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-increase-error-prone-spell-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


