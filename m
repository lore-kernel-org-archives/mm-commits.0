Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3358EC43216
	for <mm-commits@archiver.kernel.org>; Wed, 25 Aug 2021 19:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D5F6610E9
	for <mm-commits@archiver.kernel.org>; Wed, 25 Aug 2021 19:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbhHYTSp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Aug 2021 15:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235172AbhHYTSp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Aug 2021 15:18:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D78EC60F35;
        Wed, 25 Aug 2021 19:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629919079;
        bh=iSSYsEtYnR/D6bajbajTFtAChEw8sJSi4iiIyFgH7WM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jyxexarVI1B0zvGSYL0hhD6yV8Xh51wvMS5fcm094FPdsYTWpHQr3gQvL3PPxxaFf
         mks9/4rLX3lIjy1oTFiuYwX3NEn3ZPz2j+9vOyf7VutpDpafIHpjXcDoVUm/eoEaqV
         WuyIhCSVB2q/+FDjpHbsKBJoFgXxKg6wLVwUnQcg=
Date:   Wed, 25 Aug 2021 12:17:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, namjae.jeon@samsung.com,
        torvalds@linux-foundation.org
Subject:  [patch 2/2] MAINTAINERS: exfat: update my email address
Message-ID: <20210825191758.JIxP761sW%akpm@linux-foundation.org>
In-Reply-To: <20210825121725.0b4f7ca217e22d9750bc6a6d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: MAINTAINERS: exfat: update my email address

My email address in exfat entry will be not available in a few days. 
Update it to my own kernel.org address.

Link: https://lkml.kernel.org/r/20210825044833.16806-1-namjae.jeon@samsung.com
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-exfat-update-my-email-address
+++ a/MAINTAINERS
@@ -6955,7 +6955,7 @@ F:	include/uapi/linux/mdio.h
 F:	include/uapi/linux/mii.h
 
 EXFAT FILE SYSTEM
-M:	Namjae Jeon <namjae.jeon@samsung.com>
+M:	Namjae Jeon <linkinjeon@kernel.org>
 M:	Sungjong Seo <sj1557.seo@samsung.com>
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
_
