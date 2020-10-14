Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB9AC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FC1A22253
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708954;
	bh=HdiTiRGL+T1B+iKQmEyNyFkuTDom0of6S5cFsPayMUU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Uo86OzonyNCmHLqlqN2Zz0C+JDuOAtN79P+Tr1DLHnJfOACLqkrO9vbrpXeSmdbC5
	 XWU48o8gc8wysU/vYrGSIVQnJ8wIYQkD26U5I5nJPqk2+KwVbaxN4Jh8X7gBe3rbjS
	 tfndkwkOEm8OlL0uGkXje+vxHNATzgJ5GnkwexAg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388175AbgJNUzy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNUzx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:55:53 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0AEE22250;
        Wed, 14 Oct 2020 20:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708953;
        bh=HdiTiRGL+T1B+iKQmEyNyFkuTDom0of6S5cFsPayMUU=;
        h=Date:From:To:Subject:From;
        b=A2pgif7Wz8d1JLX/xEzRd03HTVmlOxkpcODeL6XtTnUbnVJOUnNe4O0YNnfBphcXO
         17fI2RHu5eA1fcQGPKhr2RdgLY7ZBmneyD1kWSRCAx8aY39ui/ZYFAFbyyTckvtcQY
         nD0VpEdl30xZmhS1uttCuDPZ9CvEJEqkI6DtP7cE=
Date:   Wed, 14 Oct 2020 13:55:52 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, j.neuschaefer@gmx.net, joe@perches.com,
        luca@lucaceresoli.net, mm-commits@vger.kernel.org,
        sjpark@amazon.de, wangqing@vivo.com, xndchn@gmail.com
Subject:  [merged] increase-error-prone-spell-checking.patch
 removed from -mm tree
Message-ID: <20201014205552.TaQu3r-wQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: increase error-prone spell checking
has been removed from the -mm tree.  Its filename was
     increase-error-prone-spell-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Qing <wangqing@vivo.com>
Subject: scripts/spelling.txt: increase error-prone spell checking

Increase direcly,ununsed,manger spelling error check

Link: https://lkml.kernel.org/r/1601085397-27586-1-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Wang Qing <wangqing@vivo.com>
Cc: Xiong <xndchn@gmail.com>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Jonathan Neuschfer <j.neuschaefer@gmx.net>
Cc: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    3 +++
 1 file changed, 3 insertions(+)

--- a/scripts/spelling.txt~increase-error-prone-spell-checking
+++ a/scripts/spelling.txt
@@ -482,6 +482,7 @@ disgest||digest
 dispalying||displaying
 diplay||display
 directon||direction
+direcly||directly
 direectly||directly
 diregard||disregard
 disassocation||disassociation
@@ -871,6 +872,7 @@ malplace||misplace
 managable||manageable
 managment||management
 mangement||management
+manger||manager
 manoeuvering||maneuvering
 manufaucturing||manufacturing
 mappping||mapping
@@ -1478,6 +1480,7 @@ unsolicitied||unsolicited
 unsuccessfull||unsuccessful
 unsuported||unsupported
 untill||until
+ununsed||unused
 unuseful||useless
 unvalid||invalid
 upate||update
_

Patches currently in -mm which might be from wangqing@vivo.com are


