Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C27C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F418461181
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhKICOx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:14:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhKICOx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:14:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C711861177;
        Tue,  9 Nov 2021 02:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636423927;
        bh=oKGjJkUujL3vluL0ZdQxRg9nzjfMZv3Cooq4jPoL4AI=;
        h=Date:From:To:Subject:From;
        b=FJaobwxdG+XGOPOCwZnrq3DDMM/JJaBbfVjxOyCB6CCNf3qDadsUaACIxfXYGtTUk
         lJd/3d35CkuA/KCLjwMYhCKku4o7/D+wXqafoj3daTg6gJ0vJo8qk2zSeQx5f097xD
         np0nTBBbIZMiHF8tfCcouZ3QhyTVkHtvEOaPhuWY=
Date:   Mon, 08 Nov 2021 18:12:07 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers-fix.patch
 removed from -mm tree
Message-ID: <20211109021207.J5D5Qg6sc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bottom_half.h needs kernel.h
has been removed from the -mm tree.  Its filename was
     kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers-fix.patch

This patch was dropped because it was folded into kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: bottom_half.h needs kernel.h

for _THIS_IP_ on arm at least

Link: https://lkml.kernel.org/r/20211015202908.1c417ae2@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bottom_half.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/bottom_half.h~kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers-fix
+++ a/include/linux/bottom_half.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_BH_H
 #define _LINUX_BH_H
 
+#include <linux/kernel.h>
 #include <linux/preempt.h>
 
 #if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_TRACE_IRQFLAGS)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers.patch
kernelh-split-out-instruction-pointer-accessors.patch

