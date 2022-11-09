Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC1CC43217
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiKIBkd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiKIBji (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:39:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707B567101
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E3E8617E8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EE0C4347C;
        Wed,  9 Nov 2022 01:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957939;
        bh=yi2LU7YFbo6zFu4I5Z5i2HOXUKRIpg1Kfcoxwqt1SQg=;
        h=Date:To:From:Subject:From;
        b=RqP3dRUUErjT4Ge0tvgQO82TIAoZzAEdU/8mJB3pRQ0hZsBxGTgZIOlknjv59Qj5x
         xFjkIDU5LmMSBRBObGTvoZesmR+sjkOy2IasiI1Plrwt5aA1nQhuCsqlHw9Qj1nKSV
         gB+jV33HuTQ1qsLPEJ2OHSdLwI0NHzvHPeaPe/Ck=
Date:   Tue, 08 Nov 2022 17:38:58 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, hch@lst.de, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-add-reviewers-for-vmalloc-code.patch removed from -mm tree
Message-Id: <20221109013859.64EE0C4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmalloc: add reviewers for vmalloc code
has been removed from the -mm tree.  Its filename was
     vmalloc-add-reviewers-for-vmalloc-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: vmalloc: add reviewers for vmalloc code
Date: Tue, 18 Oct 2022 20:10:53 +0200

Add myself and Christoph Hellwig as reviewers for vmalloc.

[akpm@linux-foundation.org: coding-style cleanups]
Link: https://lkml.kernel.org/r/20221018181053.434508-8-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~vmalloc-add-reviewers-for-vmalloc-code
+++ a/MAINTAINERS
@@ -13294,10 +13294,20 @@ F:	include/linux/memory_hotplug.h
 F:	include/linux/mm.h
 F:	include/linux/mmzone.h
 F:	include/linux/pagewalk.h
-F:	include/linux/vmalloc.h
 F:	mm/
 F:	tools/testing/selftests/vm/
 
+VMALLOC
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Uladzislau Rezki <urezki@gmail.com>
+R:	Christoph Hellwig <hch@infradead.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/vmalloc.h
+F:	mm/vmalloc.c
+
 MEMORY HOT(UN)PLUG
 M:	David Hildenbrand <david@redhat.com>
 M:	Oscar Salvador <osalvador@suse.de>
_

Patches currently in -mm which might be from urezki@gmail.com are


