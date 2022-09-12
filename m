Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F22C6FA89
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiILDb0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiILD3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B97D26135
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E85BB80C70
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE25C433D6;
        Mon, 12 Sep 2022 03:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953355;
        bh=k78xLvXqhTis1Lt5IC6W9pJ/7mMqgSlwDjOG0onUWDg=;
        h=Date:To:From:Subject:From;
        b=jMCGTZMicZKSF3XFBSmmkY6BL/rur2H+OVdZuJM9HQAXdwIsE3/qaDyyEDqNtWcAs
         slXmiWbf43P0yp3uG1ifCsRSbupvjQWFpxMZhJpm/b4SPXqVC7CDrf8ohjpYsGNh+l
         j9pDhNfiTdq3eU0ViVvfZUZyFmoytCL4pq/jqfqo=
Date:   Sun, 11 Sep 2022 20:29:14 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-zs_object_copy-replace-email-link-to-doc.patch removed from -mm tree
Message-Id: <20220912032915.4BE25C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: zs_object_copy: replace email link to doc
has been removed from the -mm tree.  Its filename was
     zsmalloc-zs_object_copy-replace-email-link-to-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Romanov <avromanov@sberdevices.ru>
Subject: zsmalloc: zs_object_copy: replace email link to doc
Date: Mon, 15 Aug 2022 17:48:25 +0300

Emails are not documentation.

[akpm@linux-foundation.org: fix whitespace damage, repair doc reference]
[akpm@linux-foundation.org: coding-style cleanups]
Link: https://lkml.kernel.org/r/20220815144825.39001-1-avromanov@sberdevices.ru
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-zs_object_copy-replace-email-link-to-doc
+++ a/mm/zsmalloc.c
@@ -1559,8 +1559,8 @@ static void zs_object_copy(struct size_c
 		 * Calling kunmap_atomic(d_addr) is necessary. kunmap_atomic()
 		 * calls must occurs in reverse order of calls to kmap_atomic().
 		 * So, to call kunmap_atomic(s_addr) we should first call
-		 * kunmap_atomic(d_addr).  For more details see
-		 * https://lore.kernel.org/linux-mm/5512421D.4000603@samsung.com/
+		 * kunmap_atomic(d_addr). For more details see
+		 * Documentation/mm/highmem.rst.
 		 */
 		if (s_off >= PAGE_SIZE) {
 			kunmap_atomic(d_addr);
_

Patches currently in -mm which might be from avromanov@sberdevices.ru are

zsmalloc-use-correct-types-in-_first_obj_offset-functions.patch

