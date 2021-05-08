Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF15C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F09F61415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhEHWj7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWj6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:39:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E3F61402;
        Sat,  8 May 2021 22:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513534;
        bh=izstgS2w1SbUiWtlnS1GYNC7nudX/PksNT24Mp0lhoI=;
        h=Date:From:To:Subject:From;
        b=uYPZIGe/qRvGZeN50/1LRXlcKyRWLi2S3tnGqeSBBEOkZN1SCEaC0mCZIEbPzV6gO
         n/GCnQgTEfKfYrdPXqhPWcwRoES9MM/zIqkBoSN1S0OJv2k9uvY7G2Gy6Ms5jhNPRG
         cfhu9RKpn5XlYUm/29yDcrHRAzZMvhucm5+RueYo=
Date:   Sat, 08 May 2021 15:38:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhang.yunkai@zte.com.cn
Subject:  [merged]
 module-remove-duplicate-include-in-arch-ia64-kernel-heads.patch removed
 from -mm tree
Message-ID: <20210508223854.DKVYdoc2k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/ia64/kernel/head.S: remove duplicate include
has been removed from the -mm tree.  Its filename was
     module-remove-duplicate-include-in-arch-ia64-kernel-heads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: arch/ia64/kernel/head.S: remove duplicate include

'linux/pgtable.h' included in 'arch/ia64/kernel/head.S' is duplicated.

Link: https://lkml.kernel.org/r/20210303084549.179346-1-zhang.yunkai@zte.com.cn
Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/head.S |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/ia64/kernel/head.S~module-remove-duplicate-include-in-arch-ia64-kernel-heads
+++ a/arch/ia64/kernel/head.S
@@ -33,7 +33,6 @@
 #include <asm/mca_asm.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
-#include <linux/pgtable.h>
 #include <asm/export.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
_

Patches currently in -mm which might be from zhang.yunkai@zte.com.cn are


