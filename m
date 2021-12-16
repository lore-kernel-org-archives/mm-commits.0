Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F61EC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Dec 2021 21:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbhLPVOz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhLPVOz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Dec 2021 16:14:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFA6C061574
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 13:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18160B82621
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 21:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A83C36AE7;
        Thu, 16 Dec 2021 21:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639689292;
        bh=oW4sNRNKqKsgaabLATHWCjH3xXMDlzaLenUblzGVklg=;
        h=Date:From:To:Subject:From;
        b=CXzE4CxPKcEDTmVe56GK0SEdRQ2+Ck26I7bHVQv4MiJKWYu+TS3BWpczVXcD4qeSI
         9yegThv61qkfdlgeeSIGI+WluoJxFt9G60y5OQ6BQvvSOm3P1L9QnfSRMLhY6r/dTt
         CA7s0TR/q8xk+AUOIiw/zKzo7VmzaWXfGq5igC8Y=
Date:   Thu, 16 Dec 2021 13:14:52 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hch@lst.de,
        andriy.shevchenko@linux.intel.com
Subject:  +
 uuid-remove-licence-boilerplate-text-from-the-header.patch added to -mm tree
Message-ID: <20211216211452.0Xi-v%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: uuid: remove licence boilerplate text from the header
has been added to the -mm tree.  Its filename is
     uuid-remove-licence-boilerplate-text-from-the-header.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/uuid-remove-licence-boilerplate-text-from-the-header.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/uuid-remove-licence-boilerplate-text-from-the-header.patch

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
Subject: uuid: remove licence boilerplate text from the header

Remove licence boilerplate text from the UAPI header.

Link: https://lkml.kernel.org/r/20211216113552.81199-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/uuid.h |    9 ---------
 1 file changed, 9 deletions(-)

--- a/include/uapi/linux/uuid.h~uuid-remove-licence-boilerplate-text-from-the-header
+++ a/include/uapi/linux/uuid.h
@@ -5,15 +5,6 @@
  *
  * Copyright (C) 2010, Intel Corp.
  *	Huang Ying <ying.huang@intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation;
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 
 #ifndef _UAPI_LINUX_UUID_H_
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

include-linux-unaligned-replace-kernelh-with-the-necessary-inclusions.patch
kernelh-include-a-note-to-discourage-people-from-including-it-in-headers.patch
list-introduce-list_is_head-helper-and-re-use-it-in-listh.patch
kunit-replace-kernelh-with-the-necessary-inclusions.patch
uuid-discourage-people-from-using-uapi-header-in-new-code.patch
uuid-remove-licence-boilerplate-text-from-the-header.patch

