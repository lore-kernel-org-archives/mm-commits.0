Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44891C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358189AbiATCJk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiATCJ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:09:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DA1C061574
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 18:09:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F332FB81C96
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D83C004E1;
        Thu, 20 Jan 2022 02:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644565;
        bh=AUnx3wIRnhbqQMQTa7Rg2ACU1zq0VZ+jrOigTj6PxbA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ytt/CHwgNJR/2psDTGNI6HR8AtXCS0Kyys0dFDv6MAOzi+N1pqeyiFSoYZTJelL6x
         qoi5r82FHyorzrURN6KmmPio7F79//fpPUanmKQVqtS4scHX/AUpldcF8/hFkQIOhh
         I3T5vp00lJwmDmUGgguByQG0M1a2190Fo/lIpaE8=
Date:   Wed, 19 Jan 2022 18:09:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 32/55] uuid: remove licence boilerplate text from
 the header
Message-ID: <20220120020925.0EuikaAxf%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
