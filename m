Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0EA5C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbiATVa4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347803AbiATVaz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9A9C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:30:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EACAAB81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864AFC340E0;
        Thu, 20 Jan 2022 21:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714252;
        bh=uyT2uu9GyupIWiK4Z5/Id7WnJTMH1ZwXqIlvq6RqT9Q=;
        h=Date:From:To:Subject:From;
        b=YZNxtMHxvt7hm6B7H1L8Kiw3o6l13woZSSGEpYZgpHxG6FtIVmTPR6v3XTQjzT9Zp
         jtZhAqk7zxmi+SKGelIs7Usn7lRxLg8ygJ6sJe0/9ORT3F3nhOQIGk0dv9M2n7510C
         UPhS98e66OrNCZnSG7a4ixsI6ioxn0HN5AWz5DRE=
Date:   Thu, 20 Jan 2022 13:30:52 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, hch@lst.de,
        mm-commits@vger.kernel.org
Subject:  [merged]
 uuid-remove-licence-boilerplate-text-from-the-header.patch removed from -mm
 tree
Message-ID: <20220120213052.Bga6w80pb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: uuid: remove licence boilerplate text from the header
has been removed from the -mm tree.  Its filename was
     uuid-remove-licence-boilerplate-text-from-the-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


