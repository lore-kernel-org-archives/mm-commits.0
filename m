Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A86AC64E69
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 18:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBDD320855
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 18:41:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMqAJCyt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgKPSlQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 13:41:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgKPSlP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 13:41:15 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 729B420855;
        Mon, 16 Nov 2020 18:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605552075;
        bh=2tyk26En1yNLrflhqc30CPGrOv12Xx2KfXbMNHCvnMU=;
        h=Date:From:To:Subject:From;
        b=HMqAJCyt2g/gYX4AivyZyb10w8XkEJ836kr2eQWQSrdlY/iyZJWsAaN057mKmDwTa
         I/nVk1/73JYtN06hJ8BbiUFu5slSoF55pJNudtEkCp0kIc35X+I/3Ywml9n2/KylLg
         JzQqZCsPzyF9hpCIN6vO2/bWHdptNcKcZbsJEVOQ=
Date:   Mon, 16 Nov 2020 10:41:15 -0800
From:   akpm@linux-foundation.org
To:     dbaryshkov@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mailmap-fix-entry-for-dmitry-baryshkov-eremin-solenikov.patch removed from
 -mm tree
Message-ID: <20201116184115.3zOW1imSb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: fix entry for Dmitry Baryshkov/Eremin-Solenikov
has been removed from the -mm tree.  Its filename was
     mailmap-fix-entry-for-dmitry-baryshkov-eremin-solenikov.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: mailmap: fix entry for Dmitry Baryshkov/Eremin-Solenikov

Change back surname to new (old) one.  Dmitry Baryshkov -> Dmitry
Eremin-Solenikov -> Dmitry Baryshkov.  Map several odd entries to main
identity.

Link: https://lkml.kernel.org/r/20201103005158.1181426-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-fix-entry-for-dmitry-baryshkov-eremin-solenikov
+++ a/.mailmap
@@ -82,7 +82,10 @@ Dengcheng Zhu <dzhu@wavecomp.com> <dengc
 Dengcheng Zhu <dzhu@wavecomp.com> <dengcheng.zhu@imgtec.com>
 Dengcheng Zhu <dzhu@wavecomp.com> <dengcheng.zhu@mips.com>
 <dev.kurt@vandijck-laurijssen.be> <kurt.van.dijck@eia.be>
-Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
+Dmitry Baryshkov <dbaryshkov@gmail.com>
+Dmitry Baryshkov <dbaryshkov@gmail.com> <[dbaryshkov@gmail.com]>
+Dmitry Baryshkov <dbaryshkov@gmail.com> <dmitry_baryshkov@mentor.com>
+Dmitry Baryshkov <dbaryshkov@gmail.com> <dmitry_eremin@mentor.com>
 Dmitry Safonov <0x7f454c46@gmail.com> <dima@arista.com>
 Dmitry Safonov <0x7f454c46@gmail.com> <d.safonov@partner.samsung.com>
 Dmitry Safonov <0x7f454c46@gmail.com> <dsafonov@virtuozzo.com>
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are


