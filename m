Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37D4C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C543461426
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhEHWor (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWoq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F6D16100C;
        Sat,  8 May 2021 22:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513824;
        bh=0wbR2YGW//JRRh6idfF24kP8yLEXDgyK06gIWb7NnF4=;
        h=Date:From:To:Subject:From;
        b=c2nNpR7KMnZw5d6YgR3onCYQf89p/6DWvFGIqIkI7HswZReijYwH44/XNQNILvxzX
         CxVivJnxns9zqlbEFbc5CYX+I3uILG7YwrhH+K5zc9dTkZK+89tBEdXCEIxz0Og4Ah
         p57WmLyXNtWcnXm3KP2MM9XEaRC3fCWflYEOTYn8=
Date:   Sat, 08 May 2021 15:43:44 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, willy@infradead.org
Subject:  [merged]
 mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document.patch removed from -mm
 tree
Message-ID: <20210508224344.aDUIj_LOE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/doc: add mm.h and mm_types.h to the mm-api document
has been removed from the -mm tree.  Its filename was
     mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/doc: add mm.h and mm_types.h to the mm-api document

kerneldoc in include/linux/mm.h and include/linux/mm_types.h wasn't being
included in the html build.

Link: https://lkml.kernel.org/r/20210322195022.2143603-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/core-api/mm-api.rst~mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document
+++ a/Documentation/core-api/mm-api.rst
@@ -92,3 +92,7 @@ More Memory Management Functions
    :export:
 
 .. kernel-doc:: mm/page_alloc.c
+.. kernel-doc:: include/linux/mm_types.h
+   :internal:
+.. kernel-doc:: include/linux/mm.h
+   :internal:
_

Patches currently in -mm which might be from willy@infradead.org are


