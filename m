Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF99C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbjDFCpy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbjDFCpJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FA8768F
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5613464230
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF75C433D2;
        Thu,  6 Apr 2023 02:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749106;
        bh=rx3Wptwu7Hm+bH5I6Cpr2UBZ++UIr950zdeXHjMBQms=;
        h=Date:To:From:Subject:From;
        b=TVLygliR6rzkmoqrQSoObdK9wQH6Ceiaze9GXjgE90p3oBKBp5P7ewLG7IKrKrRMM
         WAQlO5f60mfPZkXwg7y1pypgHXMjujHhU6niZTFRs7QhnzSYNVorpFxz0m+m6KUEJ5
         Il2dYf00yEL4h0XK7ePYvubU+A37LOlre3jYrFKI=
Date:   Wed, 05 Apr 2023 19:45:06 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, hch@infradead.org,
        bhe@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-myself-as-vmalloc-reviewer.patch removed from -mm tree
Message-Id: <20230406024506.ABF75C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add Lorenzo as vmalloc reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-vmalloc-reviewer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: MAINTAINERS: add Lorenzo as vmalloc reviewer
Date: Tue, 21 Mar 2023 18:09:55 +0000

I have recently been involved in both reviewing and submitting patches to
the vmalloc code in mm and would be willing and happy to help out with
review going forward if it would be helpful!

Link: https://lkml.kernel.org/r/55f663af6100c84a71a0065ac0ed22463aa340de.1679421959.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-vmalloc-reviewer
+++ a/MAINTAINERS
@@ -13418,6 +13418,7 @@ VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Uladzislau Rezki <urezki@gmail.com>
 R:	Christoph Hellwig <hch@infradead.org>
+R:	Lorenzo Stoakes <lstoakes@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from lstoakes@gmail.com are


