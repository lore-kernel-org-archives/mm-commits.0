Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B656FC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Dec 2021 21:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhLPVOy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhLPVOx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Dec 2021 16:14:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AACDC061574
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 13:14:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37159B80939
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 21:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F63C36AE7;
        Thu, 16 Dec 2021 21:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639689291;
        bh=Oh/GvdYqXWWffZS0j0mGOlHTs4UpCAJWpg2Iy1ivgLQ=;
        h=Date:From:To:Subject:From;
        b=BCZJlZidmvCqZ6ewifzQbfjkmE6PoWt8i2Q2iNnUAxu90xfZ/EPHn55e/5jTkGAJR
         oV5Tgyj52h/nafSY7nyRkDvsaulhaGq0a2kSvaMb8OP26v4O33P3kwUoCmejhpYJnR
         eu9m+H+cIGt26DjpJakgCziO4YUTLZuftE5iUN4o=
Date:   Thu, 16 Dec 2021 13:14:50 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hch@lst.de,
        andriy.shevchenko@linux.intel.com
Subject:  +
 uuid-discourage-people-from-using-uapi-header-in-new-code.patch added to -mm
 tree
Message-ID: <20211216211450.zP4KD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: uuid: discourage people from using UAPI header in new code
has been added to the -mm tree.  Its filename is
     uuid-discourage-people-from-using-uapi-header-in-new-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/uuid-discourage-people-from-using-uapi-header-in-new-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/uuid-discourage-people-from-using-uapi-header-in-new-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

include-linux-unaligned-replace-kernelh-with-the-necessary-inclusions.patch
kernelh-include-a-note-to-discourage-people-from-including-it-in-headers.patch
list-introduce-list_is_head-helper-and-re-use-it-in-listh.patch
kunit-replace-kernelh-with-the-necessary-inclusions.patch
uuid-discourage-people-from-using-uapi-header-in-new-code.patch
uuid-remove-licence-boilerplate-text-from-the-header.patch

