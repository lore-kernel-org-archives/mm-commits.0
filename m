Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A67C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377933AbiATVax (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347803AbiATVax (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C421C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:30:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03551B81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936BBC340E0;
        Thu, 20 Jan 2022 21:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714250;
        bh=kQFNhYzryBzjGnBrSO1uygQJszJ8J8fEpkb2zgKKWIA=;
        h=Date:From:To:Subject:From;
        b=nopYspih3JnzA8KWe0B363A3wbSJX7m325dQFYSD6ZQt3nEujQ3U3Z1Lb+9UCDP+6
         Hj+fx0Up+FGA0KeH5HYNDaXWmBbh71UuOH5qIu/+rl0k+MX/BXaj3PWOHuZcSat066
         R+05gYz4HdkqyPu+pxv67b+92jSa27CiyoY4tEvQ=
Date:   Thu, 20 Jan 2022 13:30:50 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, hch@lst.de,
        mm-commits@vger.kernel.org
Subject:  [merged]
 uuid-discourage-people-from-using-uapi-header-in-new-code.patch removed
 from -mm tree
Message-ID: <20220120213050.2TbW7L2-w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: uuid: discourage people from using UAPI header in new code
has been removed from the -mm tree.  Its filename was
     uuid-discourage-people-from-using-uapi-header-in-new-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: uuid: discourage people from using UAPI header in new code

Discourage people from using UAPI header in new code by adding a note.

Link: https://lkml.kernel.org/r/20211216113552.81199-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/uuid.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/uapi/linux/uuid.h~uuid-discourage-people-from-using-uapi-header-in-new-code
+++ a/include/uapi/linux/uuid.h
@@ -1,4 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* DO NOT USE in new code! This is solely for MEI due to legacy reasons */
 /*
  * UUID/GUID definition
  *
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


