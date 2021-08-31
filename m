Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3030C43214
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 18:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94302610E9
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 18:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbhHaSGW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Aug 2021 14:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhHaSGW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Aug 2021 14:06:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DBDD610C7;
        Tue, 31 Aug 2021 18:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630433126;
        bh=DBo8doVxygPshP3o7Ma6A5x9r87qt9/w0g2pys62CFk=;
        h=Date:From:To:Subject:From;
        b=2E58NST/7HoGKaNCaZDJHicj2md50nmsJ/a4fjC8U05BlS9LvQKBs2tct4GwwTkx3
         uLvhhz7G1PkP1SoPwGEEfK5bE2iRrcF2pKfaujwnO+L+61qUV01jqemhVy0nfqvA7g
         K0y/59HPcP1vTZ234JYj+GehAZJyCQ6xC98GkHzU=
Date:   Tue, 31 Aug 2021 11:05:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, namjae.jeon@samsung.com
Subject:  [merged] maintainers-exfat-update-my-email-address.patch
 removed from -mm tree
Message-ID: <20210831180526.cSNCtDHlI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: exfat: update my email address
has been removed from the -mm tree.  Its filename was
     maintainers-exfat-update-my-email-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from namjae.jeon@samsung.com are


