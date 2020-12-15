Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EC5C2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59853224F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgLODOA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:14:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbgLODNL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:11 -0500
Date:   Mon, 14 Dec 2020 19:12:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001944;
        bh=IFG/sYIrKZGZZ6ijJA9yrDIXg6cUtnoVBWW+FA6/bIY=;
        h=From:To:Subject:In-Reply-To:From;
        b=jryxjaaIJVR6DPxmcMXc9ou2mt6G0MYa2xKM8AVJIINqJ9Kg/YfG2OE7x+hdESbMg
         6BVZwbWp6Y8nUGP7E8VB3mKGL38kHEKbmEg+rZP3HUuAEzy2FsEFeH4M738u85xFhe
         zwdS65rNUldpMQiuvhHzudkqZMGdyIUsG08QMKXU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hymmsx.yu@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 154/200] mm/vmscan.c: remove the filename in the
 top of file comment
Message-ID: <20201215031221.6Q8ZUIEUu%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "logic.yu" <hymmsx.yu@gmail.com>
Subject: mm/vmscan.c: remove the filename in the top of file comment

No point in having the filename inside the file.

Link: https://lkml.kernel.org/r/20201115141541.3878-1-hymmsx.yu@gmail.com
Signed-off-by: logic.yu <hymmsx.yu@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmscan.c~mm-remove-the-filename-in-the-top-of-file-comment-in-vmscanc
+++ a/mm/vmscan.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *  linux/mm/vmscan.c
- *
  *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
  *
  *  Swap reorganised 29.12.95, Stephen Tweedie.
_
