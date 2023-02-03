Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354C2C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjBCGfl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjBCGfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1CE8AC0E
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E4B4B82982
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F43C4339C;
        Fri,  3 Feb 2023 06:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406126;
        bh=CzS0+uLm5VxENc8e7UnxdXR43KNXuQ4KNt3XYSwxl14=;
        h=Date:To:From:Subject:From;
        b=jD+ecHtSjVxhTEos/Ugav9CofFkHl2aDdFm2P0YEduY5NdWIfhW3WjjPrUPLCSLQj
         NfG7MMky2I608FlZCUQH5ywR03goIoFT0rXjZLEpsM+wneY/IPBPoeMUTZjscLPEJq
         RF7OLMkJyY26U33rxCqRzfHI8lD/1BuYPawerd8s=
Date:   Thu, 02 Feb 2023 22:35:25 -0800
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-fix-typo-in-comment.patch removed from -mm tree
Message-Id: <20230203063526.02F43C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: fix typo in comment
has been removed from the -mm tree.  Its filename was
     mm-mmap-fix-typo-in-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <vernon2gm@gmail.com>
Subject: mm/mmap: fix typo in comment
Date: Tue, 10 Jan 2023 22:53:53 +0800

Replace "parital" with "partial".

Link: https://lkml.kernel.org/r/20230110145353.1658435-1-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-mmap-fix-typo-in-comment
+++ a/mm/mmap.c
@@ -2889,7 +2889,7 @@ out:
 }
 
 /*
- * brk_munmap() - Unmap a parital vma.
+ * brk_munmap() - Unmap a partial vma.
  * @mas: The maple tree state.
  * @vma: The vma to be modified
  * @newbrk: the start of the address to unmap
_

Patches currently in -mm which might be from vernon2gm@gmail.com are


