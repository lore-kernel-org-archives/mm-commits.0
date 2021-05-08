Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E753BC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF5A061426
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhEHWoi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhEHWoh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9177261424;
        Sat,  8 May 2021 22:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513815;
        bh=cOAQ0ST75w1j3/w6zf3vOAFi2QshaxnHzYzS+Irxfzg=;
        h=Date:From:To:Subject:From;
        b=qrJR2C/GThq6unFoqe3p3wwAZ84TzAcMiDr9T9lPZ8aQKNAysTxK6GQj0ijNbYb09
         GoPU2zbMATQLa2p98POAOb6QCNPrcUmkB0nrimAoQ9e8YiNbb3f9+C6I9vXqE1Uv9U
         5IOPsJypGsNPAgCrdP2zWsbPsfFgHniwp0EdRQms=
Date:   Sat, 08 May 2021 15:43:35 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        shuah@kernel.org, urezki@gmail.com, willy@infradead.org
Subject:  [merged] mm-vmalloc-remove-an-empty-line.patch removed
 from -mm tree
Message-ID: <20210508224335.yq7LXaeEI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: remove an empty line
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-an-empty-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: remove an empty line

Link: https://lkml.kernel.org/r/20210402202237.20334-5-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-an-empty-line
+++ a/mm/vmalloc.c
@@ -1503,7 +1503,6 @@ retry:
 	va->va_end = addr + size;
 	va->vm = NULL;
 
-
 	spin_lock(&vmap_area_lock);
 	insert_vmap_area(va, &vmap_area_root, &vmap_area_list);
 	spin_unlock(&vmap_area_lock);
_

Patches currently in -mm which might be from urezki@gmail.com are


