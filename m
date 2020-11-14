Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A1DC63798
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12E632073C
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:51:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9FFgz3z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgKNGvu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Nov 2020 01:51:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:33228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgKNGvu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Nov 2020 01:51:50 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3841C22275;
        Sat, 14 Nov 2020 06:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605336710;
        bh=uIAaau/B5qmCErnkFMC3Pyqu2dp1MxYc0qfoMsdYJ7c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=A9FFgz3zSMHz9v2WNpwtVP+ypp2hQr4n/YfXvEdfeTNyULkwHLMgm/6USD52r4F9F
         DOu09vRBS9LBiSF/0ikguml6HCApin6rCQQ41U1jrUdroLUB5L9zs+We0FyY3AUtPr
         B6eU8oSWMreL19Cqit7UYj5cyp1rYhxxpgzDh2Ck=
Date:   Fri, 13 Nov 2020 22:51:49 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dbaryshkov@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 04/14] mailmap: fix entry for Dmitry
 Baryshkov/Eremin-Solenikov
Message-ID: <20201114065149.6dSpHAmWc%akpm@linux-foundation.org>
In-Reply-To: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
