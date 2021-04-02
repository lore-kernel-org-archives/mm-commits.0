Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DDBC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 22:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9130461186
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 22:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbhDBWBn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Apr 2021 18:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234207AbhDBWBn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Apr 2021 18:01:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 559696117A;
        Fri,  2 Apr 2021 22:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617400901;
        bh=cnnSB0a8eZX7ALwKc0q8R91tjdFF07yRlUDPp5EppAg=;
        h=Date:From:To:Subject:From;
        b=2pIL0Apw3I/aZp6D3FUPIym4e1IhU6gM05NhOLHVFm4fhdx6EOWgoh9aZYOlrrzHU
         1eopO8qnq+j7zZ39vpSKrc6ZNoaiJE66OU9fo2KjrqC/PuB/JuOq8GLotjqESfWQdy
         ZX2IlyhnUYF3drD/3ah8lckwXKpWxKpAScZFzWg8=
Date:   Fri, 02 Apr 2021 15:01:40 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        shuah@kernel.org, urezki@gmail.com, willy@infradead.org
Subject:  + mm-vmalloc-remove-an-empty-line.patch added to -mm tree
Message-ID: <20210402220140.WxLbGejo5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: remove an empty line
has been added to the -mm tree.  Its filename is
     mm-vmalloc-remove-an-empty-line.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-remove-an-empty-line.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-remove-an-empty-line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmalloc-improve-allocation-failure-error-messages-fix.patch
lib-test_vmallocc-remove-two-kvfree_rcu-tests.patch
lib-test_vmallocc-add-a-new-nr_threads-parameter.patch
vm-test_vmallocsh-adapt-for-updated-driver-interface.patch
mm-vmalloc-refactor-the-preloading-loagic.patch
mm-vmalloc-remove-an-empty-line.patch

