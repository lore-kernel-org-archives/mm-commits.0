Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77530C19F2B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239698AbiG3BNm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239752AbiG3BN0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B268BAB4
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5636761D40
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A905AC433D6;
        Sat, 30 Jul 2022 01:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143601;
        bh=mq2i2S3qp2Wwzvy1pLgLJ0+IL1mh3DGR9aPOfnPwces=;
        h=Date:To:From:Subject:From;
        b=r/u9ESP9APUfRnIuSFiEj5YeSLWXOOAj7eofQfVwOP5gTBDf5rhAnoJafGMP9SI5j
         lgV4xPrHyVZRGVBJfP9ZXYrjwlsV4ueovue4jo5m3eF3Mv4K8Jge1pYpZBEsQA/Jqj
         Ly7Zi8rFewnz9vor7q5aKUJ0AD5EE8qfERldcAs0=
Date:   Fri, 29 Jul 2022 18:13:21 -0700
To:     mm-commits@vger.kernel.org, tkhai@ya.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-kirills-email.patch removed from -mm tree
Message-Id: <20220730011321.A905AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update Kirill's email
has been removed from the -mm tree.  Its filename was
     mailmap-update-kirills-email.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -221,7 +221,7 @@ Kees Cook <keescook@chromium.org> <kees@
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


