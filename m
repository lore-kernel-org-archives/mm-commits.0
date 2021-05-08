Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE0CC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B0C8613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhEHWwb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhEHWwa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85AE261402;
        Sat,  8 May 2021 22:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514288;
        bh=vw5btEZbFZMGBqv7D7np1mlpuQ280JHPK7lopYj8CzY=;
        h=Date:From:To:Subject:From;
        b=NHxeE6n3EWbI+eSYuXKNKlCPz5vvWjxoin8Za3iX5e7oPru+xf38yrhiXBLvo37Dn
         BwaHYML5PVAU+35AmMiUEP1utzFyVkW786UPeQO5Iy7mLhYvBviwCRvgh9Xk8svyUk
         c1nK4uMvKN5qskRngHhsG646302ZPXh50rfFa0bc=
Date:   Sat, 08 May 2021 15:51:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhang.yunkai@zte.com.cn
Subject:  [merged]
 mm-process_vm_access-remove-duplicate-include.patch removed from -mm tree
Message-ID: <20210508225128.16jG8fcp6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/process_vm_access.c: remove duplicate include
has been removed from the -mm tree.  Its filename was
     mm-process_vm_access-remove-duplicate-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: mm/process_vm_access.c: remove duplicate include

'linux/compat.h' included in 'process_vm_access.c' is duplicated.

Link: https://lkml.kernel.org/r/20210306132122.220431-1-zhang.yunkai@zte.com.cn
Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/process_vm_access.c~mm-process_vm_access-remove-duplicate-include
+++ a/mm/process_vm_access.c
@@ -9,7 +9,6 @@
 #include <linux/mm.h>
 #include <linux/uio.h>
 #include <linux/sched.h>
-#include <linux/compat.h>
 #include <linux/sched/mm.h>
 #include <linux/highmem.h>
 #include <linux/ptrace.h>
_

Patches currently in -mm which might be from zhang.yunkai@zte.com.cn are


